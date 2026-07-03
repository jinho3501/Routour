import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/version_viewmodel.dart';

class VersionInfoPage extends StatelessWidget {
  const VersionInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final versionVM = Provider.of<VersionViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('버전 정보'),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/Logo/routour.png', width: 120),
            const SizedBox(height: 24),
            Text('현재 버전 ${versionVM.currentVersion}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              versionVM.isLatest ? '최신 버전입니다.' : '새로운 버전이 나왔어요!',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}