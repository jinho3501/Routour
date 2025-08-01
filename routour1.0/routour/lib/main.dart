import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'views/login/login.dart';
import 'views/home/home_page.dart';
import 'views/login/login_page.dart';
import 'views/login/signup_page.dart';
import 'views/settings/version_info_page.dart';
import 'viewmodels/home_viewmodel.dart'; // ViewModel import
import 'viewmodels/auth_viewmodel.dart'; // Added AuthViewModel import
import 'viewmodels/version_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()), // Added AuthViewModel provider
        ChangeNotifierProvider(create: (_) => HomeViewModel()), // ViewModel 전역 등록
        ChangeNotifierProvider(create: (_) => VersionViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: FirebaseAuth.instance.currentUser != null ? HomePage() : const LoginPage(),
        // nitialRoute: '/',
        routes: {
          // '/': (context) => const LoginPage(),
          '/main': (context) => HomePage(),
          '/email_login': (context) => const EmailLoginPage(),
          '/signup': (context) => const SignupPage(),
          '/version_info': (context) => const VersionInfoPage(),
        },
      ),
    );
  }
}