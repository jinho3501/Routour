import 'package:flutter/material.dart';

class VersionViewModel extends ChangeNotifier {
  final String currentVersion = '1.0';
  String latestVersion = '1.0'; // 이 값은 나중에 서버나 Remote Config에서 불러올 예정

  bool get isLatest => currentVersion == latestVersion;

  Future<void> fetchLatestVersion() async {
    // ⚠️ 나중에 서버에서 최신 버전 받아오는 로직 추가
    await Future.delayed(Duration(milliseconds: 500)); // 테스트용 지연
    latestVersion = '1.1'; // 테스트 값
    notifyListeners();
  }
}