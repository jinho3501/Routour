

import 'package:flutter/foundation.dart';
import '../../models/concept_model.dart';

class ConceptViewModel extends ChangeNotifier {
  final List<Concept> concepts = [
    Concept(
      title: '스포츠',
      iconPath: 'assets/Dummy/category/ca_1.svg',
      hotSpots: [
        Spot(name: '챔피언스필드', location: '광주광역시', imagePath: 'assets/Dummy/dum1.png'),
        Spot(name: '월드컵 경기장', location: '광주광역시', imagePath: 'assets/Dummy/dum2.png'),
        Spot(name: '아쿠아시티', location: '광주광역시', imagePath: 'assets/Dummy/dum3.png'),
        Spot(name: '남부대학교', location: '광주광역시', imagePath: 'assets/Dummy/dum4.png'),
        Spot(name: '광주 실내 빙상장', location: '광주광역시', imagePath: 'assets/Dummy/dum5.png'),
        Spot(name: '여수 유월드 루지', location: '전라남도', imagePath: 'assets/Dummy/dum6.png'),
      ],
      recommendedTours: [
        Spot(name: '기아 챔피언스필드', location: '광주광역시', imagePath: 'assets/Dummy/dum1.png'),
        Spot(name: '월드컵 경기장', location: '광주광역시', imagePath: 'assets/Dummy/dum2.png'),
      ],
    ),
    Concept(
      title: '문화',
      iconPath: 'assets/Dummy/category/ca_2.svg',
      hotSpots: [
        Spot(name: '챔피언스필드', location: '광주광역시', imagePath: 'assets/Dummy/dum1.png'),
        Spot(name: '월드컵 경기장', location: '광주광역시', imagePath: 'assets/Dummy/dum2.png'),
        Spot(name: '아쿠아시티', location: '광주광역시', imagePath: 'assets/Dummy/dum3.png'),
        Spot(name: '남부대학교', location: '광주광역시', imagePath: 'assets/Dummy/dum4.png'),
        Spot(name: '광주 실내 빙상장', location: '광주광역시', imagePath: 'assets/Dummy/dum5.png'),
        Spot(name: '여수 유월드 루지', location: '전라남도', imagePath: 'assets/Dummy/dum6.png'),
      ],
      recommendedTours: [
        Spot(name: '기아 챔피언스필드', location: '광주광역시', imagePath: 'assets/Dummy/dum1.png'),
        Spot(name: '월드컵 경기장', location: '광주광역시', imagePath: 'assets/Dummy/dum2.png'),
      ],
    ),
    Concept(
      title: '식도락',
      iconPath: 'assets/Dummy/category/ca_3.svg',
      hotSpots: [
        Spot(name: '챔피언스필드', location: '광주광역시', imagePath: 'assets/Dummy/dum1.png'),
        Spot(name: '월드컵 경기장', location: '광주광역시', imagePath: 'assets/Dummy/dum2.png'),
        Spot(name: '아쿠아시티', location: '광주광역시', imagePath: 'assets/Dummy/dum3.png'),
        Spot(name: '남부대학교', location: '광주광역시', imagePath: 'assets/Dummy/dum4.png'),
        Spot(name: '광주 실내 빙상장', location: '광주광역시', imagePath: 'assets/Dummy/dum5.png'),
        Spot(name: '여수 유월드 루지', location: '전라남도', imagePath: 'assets/Dummy/dum6.png'),
      ],
      recommendedTours: [
        Spot(name: '기아 챔피언스필드', location: '광주광역시', imagePath: 'assets/Dummy/dum1.png'),
        Spot(name: '월드컵 경기장', location: '광주광역시', imagePath: 'assets/Dummy/dum2.png'),
      ],
    ),
    Concept(
      title: '자연',
      iconPath: 'assets/Dummy/category/ca_4.svg',
      hotSpots: [
        Spot(name: '챔피언스필드', location: '광주광역시', imagePath: 'assets/Dummy/dum1.png'),
        Spot(name: '월드컵 경기장', location: '광주광역시', imagePath: 'assets/Dummy/dum2.png'),
        Spot(name: '아쿠아시티', location: '광주광역시', imagePath: 'assets/Dummy/dum3.png'),
        Spot(name: '남부대학교', location: '광주광역시', imagePath: 'assets/Dummy/dum4.png'),
        Spot(name: '광주 실내 빙상장', location: '광주광역시', imagePath: 'assets/Dummy/dum5.png'),
        Spot(name: '여수 유월드 루지', location: '전라남도', imagePath: 'assets/Dummy/dum6.png'),
      ],
      recommendedTours: [
        Spot(name: '기아 챔피언스필드', location: '광주광역시', imagePath: 'assets/Dummy/dum1.png'),
        Spot(name: '월드컵 경기장', location: '광주광역시', imagePath: 'assets/Dummy/dum2.png'),
      ],
    ),
    Concept(
      title: '관광',
      iconPath: 'assets/Dummy/category/ca_5.svg',
      hotSpots: [
        Spot(name: '챔피언스필드', location: '광주광역시', imagePath: 'assets/Dummy/dum1.png'),
        Spot(name: '월드컵 경기장', location: '광주광역시', imagePath: 'assets/Dummy/dum2.png'),
        Spot(name: '아쿠아시티', location: '광주광역시', imagePath: 'assets/Dummy/dum3.png'),
        Spot(name: '남부대학교', location: '광주광역시', imagePath: 'assets/Dummy/dum4.png'),
        Spot(name: '광주 실내 빙상장', location: '광주광역시', imagePath: 'assets/Dummy/dum5.png'),
        Spot(name: '여수 유월드 루지', location: '전라남도', imagePath: 'assets/Dummy/dum6.png'),
      ],
      recommendedTours: [
        Spot(name: '기아 챔피언스필드', location: '광주광역시', imagePath: 'assets/Dummy/dum1.png'),
        Spot(name: '월드컵 경기장', location: '광주광역시', imagePath: 'assets/Dummy/dum2.png'),
      ],
    ),
  ];

  int selectedIndex;
  ConceptViewModel({this.selectedIndex = 0});

  Concept get selectedConcept => concepts[selectedIndex];

  void updateIndex(int newIndex) {
    selectedIndex = newIndex;
    notifyListeners();
  }
}