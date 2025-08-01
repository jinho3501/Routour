import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routour/viewmodels/auth_viewmodel.dart';

class EmailLoginPage extends StatefulWidget {
  const EmailLoginPage({super.key});

  @override
  State<EmailLoginPage> createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('이메일 로그인')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final success = await authVM.signIn(
                  emailController.text,
                  passwordController.text,
                );
                if (success && context.mounted) {
                  Navigator.pushReplacementNamed(context, '/main');
                }
              },
              child: const Text('로그인'),
            ),
            const SizedBox(height: 12),
            Text(authVM.message),
          ],
        ),
      ),
    );
  }
}