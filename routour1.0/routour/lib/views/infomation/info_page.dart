import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/info_viewmodel.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InfoViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('당신만의 정보와 혜택', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Consumer<InfoViewModel>(
          builder: (context, viewModel, child) {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.infoList.length,
              itemBuilder: (context, index) {
                final item = viewModel.infoList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(item.imagePath),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}