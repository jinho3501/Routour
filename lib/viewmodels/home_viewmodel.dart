import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';

class HomeViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  // If your Firebase Storage uses a non-default bucket, set it here.
  // Example: 'gs://your-project-id.appspot.com'
  static const String? kStorageBucket = 'gs://routour-5f540.appspot.com';

  void _debugBuckets() {
    try {
      final defaultBucket = Firebase.app().options.storageBucket;
      debugPrint('[STORAGE] defaultBucket=$defaultBucket, using=${_storage.bucket}');
    } catch (e) {
      debugPrint('[STORAGE] bucket debug failed: $e');
    }
  }

  FirebaseStorage get _storage => kStorageBucket == null
      ? FirebaseStorage.instance
      : FirebaseStorage.instanceFor(bucket: kStorageBucket!);

  bool loading = false;
  String? error;

  String uid = '';
  String email = '';
  String displayName = '';
  String nickname = '';
  String? photoURL;
  int points = 0;
  int couponsCount = 0;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _sub;
  StreamSubscription<User?>? _authSub;

  HomeViewModel() {
    _debugBuckets();
    // 로그인 상태 변화에 맞춰 Firestore 구독을 붙였다 떼기
    _authSub = _auth.authStateChanges().listen((u) {
      // 기존 구독 해제
      _sub?.cancel();
      _sub = null;

      debugPrint('[AUTH] authStateChanges -> uid=${u?.uid}');

      if (u == null) {
        // 로그아웃 상태: 로컬 상태 초기화
        uid = '';
        email = '';
        displayName = '';
        nickname = '';
        photoURL = null;
        points = 0;
        couponsCount = 0;
        notifyListeners();
        return;
      }
      // 토큰을 갱신해서 rules 평가 시점의 권한 문제를 줄임
      u.getIdToken(true);
      // 로그인 상태: 해당 uid로 리스닝 시작
      uid = u.uid;
      _attach();
    });
  }
  void stopUserListen() {
    _sub?.cancel();
    _sub = null;
  }

  Future<void> _attach() async {
    debugPrint('[FIRESTORE] _attach() start, uid=$uid');
    if (uid.isEmpty) {
      final u = _auth.currentUser;
      if (u == null) return;
      uid = u.uid;
    }
    // 토큰 강제 갱신(권한 캐시 이슈 방지)
    try { await _auth.currentUser?.getIdToken(true); } catch (_) {}
    final docRef = _db.collection('users').doc(uid);
    debugPrint('[FIRESTORE] listen path=${docRef.path}');

    _sub = docRef.snapshots().listen(
      (snap) {
        final data = snap.data();
        if (data == null) return;
        email = (data['email'] ?? '') as String;
        displayName = (data['displayName'] ?? '') as String;
        nickname = (data['nickname'] ?? '') as String;
        photoURL = data['photoURL'] as String?;
        points = (data['points'] ?? 0) as int;
        couponsCount = (data['couponsCount'] ?? 0) as int;
        error = null;
        notifyListeners();
      },
      onError: (e, [st]) {
        if (e is FirebaseException && e.code == 'permission-denied') {
          error = '권한 오류: Firestore 규칙이 users/$uid 읽기를 허용하지 않습니다.';
        } else {
          error = e.toString();
        }
        debugPrint('[FIRESTORE] listen error: $e\n$st');
        // 권한 에러는 간헐적으로 토큰/세션 타이밍 문제일 수 있으니 한 번만 재시도
        if (e is FirebaseException && e.code == 'permission-denied') {
          Future.delayed(const Duration(milliseconds: 1200), () async {
            if (_auth.currentUser?.uid == uid) {
              try { await _auth.currentUser?.getIdToken(true); } catch (_) {}
              stopUserListen();
              _attach();
            }
          });
        }
        notifyListeners();
      },
      cancelOnError: false,
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    _authSub?.cancel();
    super.dispose();
  }

  Future<bool> updateNickname(String newNick) async {
    if (newNick.trim().isEmpty) return false;
    try {
      loading = true; notifyListeners();
      await _db.collection('users').doc(uid).set(
        {'nickname': newNick.trim()},
        SetOptions(merge: true),
      );
      loading = false; notifyListeners();
      return true;
    } catch (e) {
      error = e.toString();
      loading = false; notifyListeners();
      return false;
    }
  }

  Future<bool> pickAndUploadPhoto() async {
    try {
      final picker = ImagePicker();
      final x = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (x == null) return false;

      // 0) uid 보장
      if (uid.isEmpty) {
        final u = _auth.currentUser;
        if (u == null) {
          error = '로그인 정보가 없습니다.'; notifyListeners();
          return false;
        }
        uid = u.uid;
      }

      loading = true; notifyListeners();

      // 1) 파일/바이트 준비 + content-type
      final bytes = await x.readAsBytes();
      final name = x.name;
      final ext = name.contains('.') ? name.split('.').last.toLowerCase() : 'jpg';
      final contentType = ext == 'png'
          ? 'image/png'
          : (ext == 'heic' ? 'image/heic' : 'image/jpeg');

      // 2) 경로 + 버킷 로그
      final path = 'user_photos/$uid/profile_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final ref = _storage.ref(path);
      debugPrint('[PHOTO] uid=$uid');
      debugPrint('[PHOTO] bucket=${ref.bucket}');
      debugPrint('[PHOTO] ref.fullPath=${ref.fullPath}');

      // 3) 업로드
      try {
        final task = await ref.putData(bytes, SettableMetadata(contentType: contentType));
        debugPrint('[PHOTO] upload state=${task.state}'); // success 여야 정상
      } on FirebaseException catch (e, st) {
        debugPrint('[PHOTO] putData error code=${e.code}, msg=${e.message}');
        debugPrint('$st');
        if (e.code == 'object-not-found') {
          final defaultBucket = Firebase.app().options.storageBucket;
          error = 'Storage 경로/버킷 문제로 업로드 대상이 없습니다.\n(default=$defaultBucket, using=${_storage.bucket})';
          loading = false; notifyListeners();
          return false;
        }
        error = e.message ?? e.code;
        loading = false; notifyListeners();
        return false;
      }

      // 4) 메타 존재 확인(진짜 파일이 있는지)
      final meta = await ref.getMetadata();
      debugPrint('[PHOTO] size=${meta.size} bytes, contentType=${meta.contentType}');

      // 5) 다운로드 URL
      final url = await ref.getDownloadURL();
      debugPrint('[PHOTO] url=$url');

      // 6) 이전 사진 삭제 시도(있다면)
      if (photoURL != null && photoURL!.startsWith('https://')) {
        try {
          await _storage.refFromURL(photoURL!).delete();
        } catch (e) {
          debugPrint('[PHOTO] old delete skip: $e');
        }
      }

      // 7) Firestore에 photoURL 저장 (update → set 순)
      final userDoc = _db.collection('users').doc(uid);
      try {
        await userDoc.update({'photoURL': url});
      } on FirebaseException catch (e) {
        if (e.code == 'not-found') {
          await userDoc.set({'uid': uid, 'photoURL': url}, SetOptions(merge: true));
        } else {
          rethrow;
        }
      }

      photoURL = url;
      loading = false; notifyListeners();
      return true;
    } catch (e, st) {
      debugPrint('[PHOTO] error: $e\n$st');
      error = e.toString();
      loading = false; notifyListeners();
      return false;
    }
  }
}