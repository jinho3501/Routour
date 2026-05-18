import "package:cloud_firestore/cloud_firestore.dart";
import 'survey_model.dart';

class TravelPlanModel {
  // 상태 상수
  static const String STATUS_ACTIVE = 'active';
  static const String STATUS_DELETED = 'deleted';
  static const String STATUS_DRAFT = 'draft';

  final String id;          // 문서 ID(스냅샷 id 중복 저장 허용)
  final String userId;      // 소유자 UID
  final String planName;    // 계획 이름(예: "부산 2박3일 힐링")
  final DateTime createdAt; // 생성일
  final DateTime modifiedAt; // 수정일
  final String status;      // active|deleted|draft
  final SurveyResult surveyResult; // 설문 스냅샷 내장

  TravelPlanModel({
    required this.id,
    required this.userId,
    required this.planName,
    DateTime? createdAt,
    DateTime? modifiedAt,
    this.status = STATUS_ACTIVE,
    required this.surveyResult,
  })  : createdAt = createdAt ?? DateTime.now(),
        modifiedAt = modifiedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'planName': planName,
      'createdAt': Timestamp.fromDate(createdAt),
      'modifiedAt': Timestamp.fromDate(modifiedAt),
      'status': status,
      'surveyResult': surveyResult.toMap(),
    };
  }

  factory TravelPlanModel.fromMap(Map<String, dynamic> map) {
    return TravelPlanModel(
      id: (map['id'] as String?) ?? '',
      userId: (map['userId'] as String?) ?? '',
      planName: (map['planName'] as String?) ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      modifiedAt: (map['modifiedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      status: (map['status'] as String?) ?? STATUS_ACTIVE,
      surveyResult: SurveyResult.fromMap(
        (map['surveyResult'] as Map<String, dynamic>? ?? const {}),
      ),
    );
  }

  /// Firestore DocumentSnapshot 기반 팩토리 (권장)
  factory TravelPlanModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return TravelPlanModel.fromMap({
      ...data,
      'id': data['id'] ?? doc.id, // id 없으면 스냅샷 id 사용
    });
  }

  TravelPlanModel copyWith({
    String? id,
    String? userId,
    String? planName,
    DateTime? createdAt,
    DateTime? modifiedAt,
    String? status,
    SurveyResult? surveyResult,
  }) {
    return TravelPlanModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      planName: planName ?? this.planName,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      status: status ?? this.status,
      surveyResult: surveyResult ?? this.surveyResult,
    );
  }

  // 상태 헬퍼
  bool get isActive => status == STATUS_ACTIVE;
  bool get isDeleted => status == STATUS_DELETED;
  bool get isDraft => status == STATUS_DRAFT;
}
