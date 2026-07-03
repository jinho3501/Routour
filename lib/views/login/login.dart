import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _signInWithGoogle(BuildContext context, AuthViewModel authVM) async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;
    if (googleAuth.accessToken == null || googleAuth.idToken == null) {
      authVM.setMessage("Google 로그인에 실패했습니다. 다시 시도해 주세요.");
      return;
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken!,
      idToken: googleAuth.idToken!,
    );

    final success = await authVM.signInWithCredential(credential);
    if (success && context.mounted) {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFB0E5FF),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 160), // 로고 위치
              Image.asset('assets/Logo/routour.png', width: 200),
              const SizedBox(height: 25),

              const Text(
                '개인 맞춤형 여행 플랫폼',
                style: TextStyle(fontSize: 13),
              ),

              const SizedBox(height: 340), // 아이콘/로그인 묶음을 아래로 내리기 위한 여백

              // 아래쪽 묶음
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/Logo/kakao.png', width: 50),
                      const SizedBox(width: 65),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset('assets/Logo/naver.png', width: 50),
                      ),
                      const SizedBox(width: 65),
                      GestureDetector(
                        onTap: () => _signInWithGoogle(context, authVM),
                        child: Image.asset('assets/Logo/google.png', width: 50),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/email_login');
                    },
                    child: const Text(
                      'Routour 로그인',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: const Text(
                      '회원가입',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(authVM.message),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}