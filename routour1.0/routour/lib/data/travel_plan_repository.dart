import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/travel_plan_model.dart';
import '../models/survey_model.dart';

class TravelPlanRepository {
  final _col = FirebaseFirestore.instance.collection('travelPlans');

  // 설문 모델 → Firestore 맵
  Map<String, dynamic> _surveyToMap(SurveyResult s) {
    return {
      'destination': s.destination.code,
      'companion': s.companion.code,
      'duration': s.duration.code,
      'concept': s.concept.code,
      'style': s.style.code,
      'transport': s.transport.code,
      'selectedPlaces': s.selectedPlaces,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // 여행 계획 생성
  Future<String> createPlan({
    required String userId,
    required String planName,
    required SurveyResult survey,
  }) async {
    final doc = _col.doc();
    await doc.set({
      'id': doc.id,
      'userId': userId,
      'planName': planName,
      'status': TravelPlanModel.STATUS_ACTIVE,
      'createdAt': FieldValue.serverTimestamp(),
      'modifiedAt': FieldValue.serverTimestamp(),
      'surveyResult': _surveyToMap(survey),
    });
    return doc.id;
  }
}
