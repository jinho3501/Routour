import 'package:flutter/material.dart';
import '../models/info_model.dart';

class InfoViewModel extends ChangeNotifier {
  final List<InfoItem> _infoList = [
    InfoItem(imagePath: 'assets/Dummy/Event/event_1.png', title: '충장축제'),
    InfoItem(imagePath: 'assets/Dummy/Event/event_2.png', title: '김치축제'),
    InfoItem(imagePath: 'assets/Dummy/Event/event_3.png', title: '대중교통 캠페인'),
  ];

  List<InfoItem> get infoList => _infoList;
}