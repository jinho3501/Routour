// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'viewmodels/home_viewmodel.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/version_viewmodel.dart';

import 'views/home/home_page.dart';
import 'views/login/login.dart';
import 'views/login/login_page.dart';
import 'views/login/signup_page.dart';
import 'views/settings/version_info_page.dart';

import 'utils/firestore_user.dart'; // ensureUserDoc

// ✅ firebase_options.dart 가 생성되어 있다면 이 import 사용
// flutterfire configure 후 자동 생성됨
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ 권장: flutterfire configure 로 생성된 옵션 사용
  // 없다면 아래 한 줄로 대체 가능: await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => VersionViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // ✅ AuthGate가 로그인/로그아웃 상태에 따라 화면을 분기하고
        //    로그인되면 ensureUserDoc()을 1회 실행해 users/{uid}를 보장함
        home: const AuthGate(),
        routes: {
          '/main': (context) => HomePage(),
          '/email_login': (context) => const EmailLoginPage(),
          '/signup': (context) => const SignupPage(),
          '/version_info': (context) => const VersionInfoPage(),
        },
      ),
    );
  }
}

/// 로그인 상태에 따라 진입 화면을 바꾸고,
/// 로그인되면 users/{uid} 문서를 보장한다.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _ranEnsure = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        // 초기 로딩
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snap.data;
        if (user == null) {
          // 로그아웃 상태 → 로그인 화면
          _ranEnsure = false; // 다음 로그인 때 다시 ensureUserDoc 실행하도록 리셋
          return const LoginPage();
        }

        // 로그인 상태 → ensureUserDoc 1회 실행
        if (!_ranEnsure) {
          _ranEnsure = true;
          // 프레임 이후 한 번만 실행하여 build 중 setState 방지
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            try {
              await ensureUserDoc(); // users/{uid} 생성/갱신
            } catch (e) {
              // 필요 시 로그/스낵바 처리
              // debugPrint('ensureUserDoc error: $e');
            }
          });
        }

        // 홈 화면 진입
        return HomePage();
      },
    );
  }
}
