import 'package:flutter/material.dart';

class ScheduleViewModel extends ChangeNotifier {
  String? region;        // 떠나는 여행지
  String? companion;     // 동행
  String? period;        // 기간
  String? concept;       // 컨셉
  String? style;         // 스타일
  String? transport;     // 이동수단
  List<String> liked = []; // 좋아요 장소

  void setRegion(String v)    { region = v;    notifyListeners(); }
  void setCompanion(String v) { companion = v; notifyListeners(); }
  void setPeriod(String v)    { period = v;    notifyListeners(); }
  void setConcept(String v)   { concept = v;   notifyListeners(); }
  void setStyle(String v)     { style = v;     notifyListeners(); }
  void setTransport(String v) { transport = v; notifyListeners(); }

  void toggleLike(String place) {
    liked.contains(place) ? liked.remove(place) : liked.add(place);
    notifyListeners();
  }
  void reset(){
    region = null;
    companion = null;
    period = null;
    concept = null;
    style = null;
    transport = null;
    liked = [];
    notifyListeners();
  }
}