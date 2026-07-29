import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class RoutourApi {
  // iOS 시뮬레이터는 localhost로 맥에 접근 가능
  // (Android 에뮬레이터면 'http://10.0.2.2:8000' 으로 바꿔야 함)
  static const String baseUrl = 'http://localhost:8000';

  /// 현재 로그인한 유저의 Firebase ID 토큰을 붙인 헤더를 만든다.
  static Future<Map<String, String>> _authHeaders() async {
    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    if (token == null) {
      throw Exception('로그인이 필요합니다 (토큰 없음)');
    }
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  /// 로그인 직후 호출. 백엔드에 유저가 없으면 생성, 있으면 로그인 시각 갱신.
  static Future<Map<String, dynamic>> syncMe({
    required String email,
    String displayName = '',
    String nickname = '',
    bool agreeTos = false,
    bool agreePrivacy = false,
    bool agreeMarketing = false,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/users/me/sync'),
      headers: await _authHeaders(),
      body: jsonEncode({
        'email': email,
        'display_name': displayName,
        'nickname': nickname,
        'agree_tos': agreeTos,
        'agree_privacy': agreePrivacy,
        'agree_marketing': agreeMarketing,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception('syncMe 실패 (${res.statusCode}): ${res.body}');
    }
    return jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
  }

  /// 내 프로필 조회
  static Future<Map<String, dynamic>> getMe() async {
    final res = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: await _authHeaders(),
    );

    if (res.statusCode != 200) {
      throw Exception('getMe 실패 (${res.statusCode}): ${res.body}');
    }
    return jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
  }
}