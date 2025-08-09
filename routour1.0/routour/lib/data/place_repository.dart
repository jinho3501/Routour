import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceRepository {
  final _col = FirebaseFirestore.instance.collection('places');

  Future<Map<String, dynamic>?> getById(String placeId) async {
    final s = await _col.doc(placeId).get();
    return s.data();
  }

  /// 태그 기반 인기 장소 (예: 'nature')
  Future<List<Map<String, dynamic>>> fetchByTag({
    required String tag,
    int limit = 20,
  }) async {
    final q = await _col
        .where('tags', arrayContains: tag)
        .orderBy('score', descending: true)
        .limit(limit)
        .get();
    return q.docs.map((d) => d.data()).toList();
  }

  /// 간단 검색 (name prefix) — 인덱스 부담 줄이려면 Cloud Functions/Algolia 고려
  Future<List<Map<String, dynamic>>> searchByNamePrefix(String prefix, {int limit = 20}) async {
    // Firestore는 대소문자/부분일치가 빡셈. 간단 prefix만 처리 (정규화 필드가 있으면 거기에 적용)
    final q = await _col
        .where('name', isGreaterThanOrEqualTo: prefix)
        .where('name', isLessThan: '${prefix}z')
        .limit(limit)
        .get();
    return q.docs.map((d) => d.data()).toList();
  }
}
