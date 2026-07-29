import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:routour/services/api/routour_api.dart';

class AuthViewModel extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;

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

      // 백엔드에 유저 생성 + 약관 동의 저장
      await _ensureUserDoc(
        cred.user!,
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
      await _ensureUserDoc(cred.user!);
      return true;
    } catch (e) {
      setMessage(e.toString());
      return false;
    }
  }

  Future<bool> signInWithCredential(AuthCredential credential) async {
    try {
      final cred = await _auth.signInWithCredential(credential);
      await _ensureUserDoc(cred.user!);
      return true;
    } catch (e) {
      setMessage(e.toString());
      return false;
    }
  }


  Future<void> _ensureUserDoc(
      User u, {
        String? displayName,
        String? nickname,
        bool agreeTos = false,
        bool agreePrivacy = false,
        bool agreeMarketing = false,
      }) async {
    try {
      await RoutourApi.syncMe(
        email: (u.email ?? '').toLowerCase(),
        displayName: displayName ?? u.displayName ?? '',
        nickname: nickname ?? '',
        agreeTos: agreeTos,
        agreePrivacy: agreePrivacy,
        agreeMarketing: agreeMarketing,
      );
    } catch (e) {
      setMessage('백엔드 동기화 실패: $e');
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