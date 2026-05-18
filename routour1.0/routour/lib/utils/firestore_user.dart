// lib/utils/firestore_user.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// users/{uid} 문서를 보장한다.
/// - 문서가 없으면 생성하고 true 반환
/// - 문서가 있으면 lastLoginAt만 갱신하고 false 반환
/// - 선택적으로 displayName/email을 덮어쓸 수 있다(초기 null 방지용)
Future<bool> ensureUserDoc({
  String? displayNameOverride,
  String? emailOverride,
}) async {
  final auth = FirebaseAuth.instance;
  final user = auth.currentUser;
  if (user == null) return false; // 로그인 전

  final col = FirebaseFirestore.instance.collection('users');
  final docRef = col.doc(user.uid);

  try {
    final snap = await docRef.get();

    // 공통 프로필 필드(override가 있으면 우선 적용)
    final String? finalName = displayNameOverride ?? user.displayName;
    final String? finalEmail = emailOverride ?? user.email;

    if (!snap.exists) {
      // 최초 생성
      await docRef.set({
        'uid': user.uid,
        'name': finalName,                     // null 가능(추후 업데이트)
        'email': finalEmail,                   // null 가능
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'likedPlaces': <String>[],
        'recentViews': <String>[],
        'preferences': <String, dynamic>{},
      });
      return true; // created
    } else {
      // 이미 있으면 로그인 시간 갱신 + 선택적 프로필 병합
      final updateData = <String, dynamic>{
        'lastLoginAt': FieldValue.serverTimestamp(),
      };
      if (finalName != null) updateData['name'] = finalName;
      if (finalEmail != null) updateData['email'] = finalEmail;

      await docRef.update(updateData);
      return false; // updated
    }
  } on FirebaseException catch (e) {
    // 권한/네트워크/존재하지 않는 경로 등
    // 필요하다면 로깅 후 rethrow
    rethrow;
  }
}

/// 현재 로그인 유저의 users/{uid} 문서를 1회 조회한다.
/// 없으면 null 반환.
Future<Map<String, dynamic>?> getCurrentUserDataOnce() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();

  return doc.data();
}

/// 현재 로그인 유저의 users/{uid} 문서를 실시간 구독한다.
/// 문서가 삭제되면 null을 흘려보낸다.
Stream<Map<String, dynamic>?> watchCurrentUserData() {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // 로그인 전엔 빈 스트림
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((s) => s.data());
}
