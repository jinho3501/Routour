import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserRepository {
  final _col = FirebaseFirestore.instance.collection('users');

  /// 로그인 직후: 유저 문서 보장(없으면 생성, 있으면 lastLoginAt 갱신)
  Future<void> ensureCurrentUserDoc() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = _col.doc(user.uid);
    final snap = await doc.get();

    if (!snap.exists) {
      await doc.set({
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'likedPlaces': [],
        'recentViews': [],
        'preferences': {},
      });
    } else {
      await doc.update({'lastLoginAt': FieldValue.serverTimestamp()});
    }
  }

  Future<UserModel?> getById(String uid) async {
    final snap = await _col.doc(uid).get();
    if (!snap.exists) return null;
    return UserModel.fromMap(snap.data()!);
  }

  Stream<UserModel?> watchById(String uid) {
    return _col.doc(uid).snapshots().map((s) {
      if (!s.exists) return null;
      return UserModel.fromMap(s.data()!);
    });
  }

  Future<void> updatePreferences(String uid, Map<String, dynamic> prefs) async {
    await _col.doc(uid).update({'preferences': prefs});
  }

  Future<void> toggleLikedPlace(String uid, String placeId, bool like) async {
    await _col.doc(uid).update({
      'likedPlaces':
      like ? FieldValue.arrayUnion([placeId]) : FieldValue.arrayRemove([placeId]),
    });
  }
}
