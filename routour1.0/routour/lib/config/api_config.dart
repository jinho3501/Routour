class TourBaseApiConfig {
  static const String apiKey = '3E3iS33CAJE6EpEsu3Hd%2FE%2FPdewgLmxzryuvS247XlpRayw35vWtp7AltmE%2BR%2BnY5uf%2F8mga7soyagbml6BxiQ%3D%3D';
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