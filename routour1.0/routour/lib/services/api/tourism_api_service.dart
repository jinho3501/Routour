import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:routour/config/api_config.dart';

class TourApiService {
  // 기본 API 요청 파라미터
  Map<String, String> get _baseParams => {
    'serviceKey': TourBaseApiConfig.apiKey,
    'MobileOS': 'AND',           // 필수 파라미터
    'MobileApp': 'Routour',      // 필수 파라미터
    '_type': 'json',             // JSON 형식으로 응답 요청
  };

  Future<Map<String, dynamic>> getAreaBasedList({
    required int pageNo,
    required int numOfRows,
    String? areaCode,
    String? contentTypeId,
  }) async {
    try {
      final params = {
        ..._baseParams,
        'pageNo': pageNo.toString(),
        'numOfRows': numOfRows.toString(),
        if (areaCode != null) 'areaCode': areaCode,
        if (contentTypeId != null) 'contentTypeId': contentTypeId,
      };

      // URL 디버깅을 위한 출력
      final uri = Uri.parse('${TourInfoApiConfig.serviceUrl}/areaBasedList')
          .replace(queryParameters: params);
      print('Request URL: $uri'); // 실제 요청 URL 확인

      final response = await http.get(uri);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('API 호출 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('Error details: $e');
      throw Exception('데이터 조회 실패: $e');
    }
  }
}