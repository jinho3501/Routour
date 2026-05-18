import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostRepository {
  final _col = FirebaseFirestore.instance.collection('posts');

  Future<String> create({
    required String title,
    String? content,
    List<String>? images,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw Exception('Not signed in');

    final doc = _col.doc();
    await doc.set({
      'authorId': uid,
      'title': title,
      'content': content ?? '',
      'images': images ?? [],
      'likeCount': 0,
      'commentCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Stream<List<Map<String, dynamic>>> watchRecent({int limit = 20}) {
    return _col
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => d.data()).toList());
  }

  Future<void> like(String postId) async {
    final doc = _col.doc(postId);
    await doc.update({'likeCount': FieldValue.increment(1)});
  }
}
