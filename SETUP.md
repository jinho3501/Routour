# 🔧 Routour 셋업 가이드

본 저장소에는 보안을 위해 **Firebase 설정 파일과 TourAPI 키가 제외**되어 있습니다.
앱을 빌드하려면 아래 단계를 따라 본인의 키로 채워주세요.

---

## ⚙️ 사전 요구사항

| 도구 | 버전 |
|---|---|
| Flutter SDK | 3.x 이상 |
| Dart SDK | 3.x (Flutter에 포함) |
| Xcode | 15+ (iOS 빌드) |
| Android Studio | Hedgehog 이상 |
| CocoaPods | 1.15+ |

```bash
flutter doctor
```

---

## 1️⃣ Firebase 설정

### A. Firebase 프로젝트 생성
1. [Firebase Console](https://console.firebase.google.com/)에서 새 프로젝트 생성 (예: `my-routour`)
2. **Authentication** 활성화 — Email/Password + Google 로그인 사용 설정
3. **Cloud Firestore** 활성화 (테스트 모드 또는 보안 규칙 설정)
4. iOS / Android 앱 등록
   - Android 패키지명: 본인 설정에 맞게
   - iOS Bundle ID: 본인 설정에 맞게

### B. 설정 파일 다운로드 후 배치

| 파일 | 다운로드 위치 | 배치 경로 |
|---|---|---|
| `google-services.json` | Firebase Console → Android 앱 | `routour1.0/routour/android/app/google-services.json` |
| `GoogleService-Info.plist` | Firebase Console → iOS 앱 | `routour1.0/routour/ios/Runner/GoogleService-Info.plist` |

### C. `firebase_options.dart` 자동 생성

```bash
# FlutterFire CLI 설치 (최초 1회)
dart pub global activate flutterfire_cli

# 프로젝트 루트에서
cd routour1.0/routour
flutterfire configure
```

→ `lib/firebase_options.dart`가 자동 생성됩니다.

### D. Firestore 보안 규칙 (권장)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    match /travel_plans/{planId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

## 2️⃣ TourAPI 키 발급 & 설정

### A. [공공데이터포털](https://www.data.go.kr/)에서 키 발급
1. 회원가입 + 로그인
2. 검색: **"한국관광공사 국문 관광정보 서비스"** → 활용신청
3. 동시에 신청 권장:
   - **"한국관광공사 관광사진 정보"** (PhotoGalleryService)
   - **"한국관광공사 관광지별 연관 관광지 정보"** (TarRlteTarService)
4. 승인 후 마이페이지 → 인증키 발급 (Encoding 키 사용)

### B. 키 적용 방법 (둘 중 하나)

#### 방법 1: 빌드 시 환경변수로 주입 (권장)
```bash
flutter run --dart-define=TOUR_API_KEY=YOUR_ENCODED_KEY_HERE
```

#### 방법 2: defaultValue 직접 교체 (절대 commit 금지!)
`routour1.0/routour/lib/config/api_config.dart` 수정:
```dart
static const String apiKey = String.fromEnvironment(
  'TOUR_API_KEY',
  defaultValue: '여기에_본인_키',  // ⚠️ git commit 금지
);
```

### C. 활용 가능한 API 목록 (본 프로젝트에서 사용)
| API | 엔드포인트 | 용도 |
|---|---|---|
| areaBasedList | `/B551011/KorService2/areaBasedList` | 지역 기반 관광지 목록 |
| PhotoGallery | `/B551011/PhotoGalleryService1` | 관광사진 |
| TarRlteTar | `/B551011/TarRlteTarService1` | 연관 관광지 추천 |

---

## 3️⃣ 의존성 설치 & 실행

```bash
cd routour1.0/routour

# 1) Flutter 패키지
flutter pub get

# 2) iOS Pods (Mac만)
cd ios && pod install && cd ..

# 3) 실행
flutter run --dart-define=TOUR_API_KEY=YOUR_KEY
```

---

## 🐛 트러블슈팅

| 증상 | 해결 |
|---|---|
| `MissingPluginException: firebase_core` | `flutter clean && flutter pub get && cd ios && pod install` |
| `firebase_options.dart not found` | `flutterfire configure` 다시 실행 |
| `googleSignIn cancelled` | `google-services.json`의 SHA-1 fingerprint를 Firebase Console에 등록 |
| TourAPI 401 / 403 | 인증키 encoding/decoding 확인. URL에는 **Encoding 키** 사용 |
| Firestore 권한 오류 | 보안 규칙(`firestore.rules`) 확인. 테스트용은 `allow read, write: if request.auth != null;` |

---

## 🔒 보안 권장사항

본 코드를 fork하거나 참조할 때:

1. ✅ **TourAPI 키 노출 금지** — `.gitignore`로 보호되는 파일을 절대 commit 하지 마세요
2. ✅ **Firebase Security Rules** 설정 — 인증된 사용자만 본인 데이터 접근
3. ✅ **Firebase App Check** 활성화 — 비인가 클라이언트 차단
4. ✅ **공공데이터포털 일일 한도** 확인 — 무료 한도 초과 시 호출 차단됨
5. ✅ **Google Sign-In SHA-1** — Android는 디버그/릴리즈 키 각각 등록

---

## 📞 문의

Routour는 **WIP(Work In Progress)** 프로젝트입니다.
질문/제안은 GitHub Issues로 남겨주세요.
