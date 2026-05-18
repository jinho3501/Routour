class TourBaseApiConfig {
  // 한국관광공사 TourAPI 키 (공공데이터포털에서 발급)
  // 빌드 시 --dart-define=TOUR_API_KEY=... 로 주입하거나
  // 본인의 키로 defaultValue를 교체하세요 (단, 절대 git commit 금지)
  static const String apiKey = String.fromEnvironment(
    'TOUR_API_KEY',
    defaultValue: 'YOUR_TOUR_API_KEY_HERE',
  );
  static const String baseUrl = 'https://apis.data.go.kr';  // 공통 부분만 baseUrl로 설정
}

class TourInfoApiConfig {
  // 한국관광공사_국문 관광정보 서비스
  static const String serviceUrl = '${TourBaseApiConfig.baseUrl}/B551011/KorService2';
  static const String apiKey = TourBaseApiConfig.apiKey;
}

class TourPhotoApiConfig {
  // 한국관광공사_관광사진 정보
  static const String serviceUrl = '${TourBaseApiConfig.baseUrl}/B551011/PhotoGalleryService1';
  static const String apiKey = TourBaseApiConfig.apiKey;
}

class TourRelatedApiConfig {
  // 한국관광공사_관광지별 연관 관광지 정보
  static const String serviceUrl = '${TourBaseApiConfig.baseUrl}/B551011/TarRlteTarService1';
  static const String apiKey = TourBaseApiConfig.apiKey;
}