import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  String message = '';
  void setMessage(String m) {
    message = m;
    notifyListeners();
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String displayName,
    required String nickname,
    required bool agreeTos,
    required bool agreePrivacy,
    required bool agreeMarketing,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // FirebaseAuth 표시 이름(옵션)
      try { await cred.user?.updateDisplayName(displayName); } catch (_) {}

      await _ensureUserDoc(cred.user!, updateOnly: false);

      // Firestore 프로필/동의 저장
      await saveProfileAndConsents(
        displayName: displayName,
        nickname: nickname,
        agreeTos: agreeTos,
        agreePrivacy: agreePrivacy,
        agreeMarketing: agreeMarketing,
      );
      return true;
    } catch (e) {
      setMessage(e.toString());
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _ensureUserDoc(cred.user!, updateOnly: true);
      return true;
    } catch (e) {
      setMessage(e.toString());
      return false;
    }
  }

  Future<bool> signInWithCredential(AuthCredential credential) async {
    try {
      final cred = await _auth.signInWithCredential(credential);
      await _ensureUserDoc(cred.user!, updateOnly: true);
      return true;
    } catch (e) {
      setMessage(e.toString());
      return false;
    }
  }

  Future<void> saveProfileAndConsents({
    required String displayName,
    required String nickname,
    required bool agreeTos,
    required bool agreePrivacy,
    required bool agreeMarketing,
  }) async {
    final u = _auth.currentUser;
    if (u == null) return;
    final ref = _db.collection('users').doc(u.uid);

    // 예시 약관 버전(추후 교체)
    const tosVersion = 'v1.0';
    const privacyVersion = 'v1.0';
    const marketingVersion = 'v1.0';

    await ref.set({
      'displayName': displayName,
      'nickname': nickname,
      'terms': {
        'tos': {
          'agreed': agreeTos,
          'version': tosVersion,
          'at': agreeTos ? FieldValue.serverTimestamp() : null,
        },
        'privacy': {
          'agreed': agreePrivacy,
          'version': privacyVersion,
          'at': agreePrivacy ? FieldValue.serverTimestamp() : null,
        },
        'marketing': {
          'agreed': agreeMarketing,
          'version': marketingVersion,
          'at': agreeMarketing ? FieldValue.serverTimestamp() : null,
        },
      },
    }, SetOptions(merge: true));
  }

  Future<void> _ensureUserDoc(User u, {required bool updateOnly}) async {
    final ref = _db.collection('users').doc(u.uid);
    final data = {
      'uid': u.uid,
      'email': (u.email ?? '').toLowerCase(),
      'displayName': u.displayName ?? '',
      'photoURL': u.photoURL,
      'lastLoginAt': FieldValue.serverTimestamp(),
    };

    if (updateOnly) {
      await ref.set(data, SetOptions(merge: true));
    } else {
      await ref.set({
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'points': 0,
        'couponsCount': 0,
        'recent': [],
        'settings': {'pushEnabled': true, 'marketingOptIn': false, 'locale': 'ko_KR'},
        'terms': {
          'privacy':  {'agreed': false, 'version': null, 'at': null},
          'tos':      {'agreed': false, 'version': null, 'at': null},
          'marketing':{'agreed': false, 'version': null, 'at': null},
        },
      }, SetOptions(merge: true));
    }
  }

  Future<void> signOut() async {
    // Google 연결이 되어 있다면 로그아웃 시도 (예외는 무시)
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    // FirebaseAuth 로그아웃
    await _auth.signOut();

    // 필요 시 로컬 상태 초기화 자리 (예: message = '')
    try {
      // message = '';
    } catch (_) {}

    notifyListeners();
  }
}