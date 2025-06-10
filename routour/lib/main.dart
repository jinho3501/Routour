import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Login.dart';
import 'Home.dart';
import 'Routor_Login/Login_page.dart';
import 'Routor_Login/Signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),        // 소셜 로그인 메인 화면
        '/main': (context) => const HomePage(),     // 로그인 후 홈
        '/email_login': (context) => const EmailLoginPage(), // 이메일 로그인
        '/signup': (context) => const SignupPage(),           // 회원가입
      },
    );
  }
}