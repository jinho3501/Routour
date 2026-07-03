# 🗺 Routour (루투어)

> **광주·전남·전북을 위한 맞춤 여행 플래너** — 사용자 취향 설문을 기반으로 여행 일정·코스를 추천하는 Flutter 모바일 앱

<p align="left">
  <img src="https://img.shields.io/badge/status-🚧%20WIP-orange" alt="WIP"/>
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/Firebase-Auth%20%2B%20Firestore-FFCA28?logo=firebase&logoColor=black" alt="Firebase"/>
  <img src="https://img.shields.io/badge/Provider-MVVM-purple" alt="MVVM"/>
  <img src="https://img.shields.io/badge/TourAPI-한국관광공사-2C5F2D" alt="TourAPI"/>
</p>

---

## 🚧 Status: Work In Progress

이 프로젝트는 **개발 진행 중**입니다.

- ✅ **현재**: 화면 구조·아키텍처·인증·외부 API 연동 등 **기반 동작은 모두 구현**
- 🚧 **진행 중**: 비즈니스 로직(설문→추천 알고리즘), UI 폴리싱, 데이터 시드
- 📅 **다음**: TourAPI 응답 캐싱, 추천 정확도 개선, App Store/Play Store 출시 준비

UI 일부는 placeholder이고, 일부 ViewModel은 아직 비즈니스 로직이 비어있습니다. 본 저장소는 진호의 **아키텍처 학습 + 점진적 개발 과정**을 그대로 공개한 living project입니다.

---

## 🎯 컨셉 & 차별점

### 무엇을 만드는가
> "여행 가고 싶은데 어디 갈지 모르겠는 사람"을 위한 **6축 설문 기반 맞춤 추천**

### 6축 설문 모델 ([`survey_model.dart`](routour1.0/routour/lib/models/survey_model.dart))
| 축 | 선택지 |
|---|---|
| 📍 지역 | 광주광역시 / 전라남도 / 전라북도 |
| 👥 동행인 | 혼자 / 친구 / 반려동물 / 가족 / 연인 / 외국인 |
| 📅 기간 | 당일치기 / 1박2일 / 2박3일 / 3박4일 / 4박5일 / 5박이상 |
| 🎨 컨셉 | 스포츠 / 문화 / 먹거리 / 자연 / 관광 / 사진 |
| 🌊 스타일 | 액티비티 / 여유로운 / 빡빡한 / 힐링 / 야간여행 / 문화체험 |
| 🚗 이동수단 | 도보 / 자동차 / 자전거 / 오토바이 / 대중교통 |

### 데이터 모델 설계 포인트
- **enum 기반 타입 안전** — `Destination.gwangju` 같은 컴파일 타임 검증
- **DB code / UI label 분리** — `('광주광역시', 'gwangju')` 패턴으로 라벨 변경에도 DB 안정
- **Firestore Timestamp ↔ DateTime 안전 변환** — null safety + `copyWith` 패턴

---

## 🏗 아키텍처 — MVVM + Repository Pattern

```
┌────────────────────────────────────────────────────┐
│  Views (UI Layer)                                  │
│  views/{home,login,settings,magazine,concept,...}  │
│  → Consumer<ViewModel>로 데이터 구독                │
└────────────────────────────────────────────────────┘
                    │  ChangeNotifier
                    ▼
┌────────────────────────────────────────────────────┐
│  ViewModels (Presentation Logic)                   │
│  viewmodels/{home,auth,concept,magazine,...}       │
│  → 상태 관리 + 비즈니스 로직 호출                  │
└────────────────────────────────────────────────────┘
                    │
                    ▼
┌────────────────────────────────────────────────────┐
│  Repositories (Data Access Layer)                  │
│  data/{user,post,place,travel_plan}_repository     │
│  → Firestore CRUD + 외부 API 호출 추상화           │
└──────────────┬─────────────────┬───────────────────┘
               │                 │
               ▼                 ▼
       ┌──────────────┐  ┌──────────────────────┐
       │ Firestore    │  │ Services             │
       │ (users,      │  │ tourism_api_service  │
       │  travel_plan)│  │ (한국관광공사 API)   │
       └──────────────┘  └──────────────────────┘
```

### 왜 이 아키텍처?
- **Provider + MVVM** — RunInk(setState만 사용)에서 학습한 한계를 극복하기 위해 의도적으로 도입
- **Repository pattern** — 데이터 출처(Firestore/API)와 UI를 분리해 테스트 가능성·확장성 확보
- **MultiProvider** — `AuthViewModel`, `HomeViewModel`, `VersionViewModel`을 전역 주입

---

## ✨ 주요 기능 & 구현 상태

### ✅ 구현 완료
- 🔐 **Firebase Auth** + Google Sign-In + 이메일/비밀번호 로그인
- 🚪 **AuthGate 패턴** ([`main.dart:64~112`](routour1.0/routour/lib/main.dart)) — 로그인 상태 자동 라우팅 + 로그인 시 `users/{uid}` 문서 자동 보장(`ensureUserDoc()`)
- 📋 **6축 설문 모델** — enum 기반 type-safe 도메인 모델 완성
- 🏠 **홈 페이지 골격** (707 LOC) — 매거진/팝업/컨셉 카드 UI
- 🌐 **TourAPI 서비스 클래스** ([`tourism_api_service.dart`](routour1.0/routour/lib/services/api/tourism_api_service.dart)) — `getAreaBasedList` 등 한국관광공사 API 3종 연동
- 📚 **MVVM + Repository 골격** — `views`, `viewmodels`, `data`, `services` 폴더 구조

### 🚧 진행 중
- 🎯 **설문 → 여행 코스 추천 알고리즘** (현재 `home_viewmodel.dart`가 비어있음 — 비즈니스 로직 작성 예정)
- 📷 **TourPhotoAPI / TourRelatedAPI** 연동 마무리
- 🗺 **여행 일정 표시 UI** (`travel_plan_model.dart`는 있으나 화면 미완성)

### 📅 예정
- 💾 **TourAPI 응답 Firestore 캐싱** (호출 한도 절약)
- ⭐ **사용자 리뷰·즐겨찾기 기능**
- 🗺 **Google Maps 지도 통합**
- 📱 **App Store / Play Store 출시**

---

## 🗂 프로젝트 구조

```
Routour/
├── routour/              ← v0 (초기 학습용, 단순 UI 위주)
│   └── lib/
│       ├── main.dart, Home.dart, Login.dart
│       └── Routor_Login/{Login,Signup}_page.dart
│
└── routour1.0/           ← v1.0 (현재 메인, MVVM 도입)
    └── routour/
        ├── lib/
        │   ├── main.dart                  # AuthGate + MultiProvider
        │   ├── firebase_options.dart      # ⚠️ git ignored (SETUP.md)
        │   │
        │   ├── config/
        │   │   └── api_config.dart        # ⚠️ TourAPI 키 환경변수
        │   │
        │   ├── models/                    # 도메인 모델
        │   │   ├── survey_model.dart      # 6축 설문 (enum 기반)
        │   │   ├── travel_plan_model.dart # 여행 계획
        │   │   ├── user_model.dart
        │   │   ├── concept_model.dart
        │   │   └── info_model.dart
        │   │
        │   ├── viewmodels/                # ChangeNotifier 기반 VM
        │   │   ├── auth_viewmodel.dart
        │   │   ├── home_viewmodel.dart
        │   │   ├── concept_viewmodel.dart
        │   │   ├── magazine_viewmodel.dart
        │   │   ├── popular_viewmodel.dart
        │   │   ├── info_viewmodel.dart
        │   │   └── version_viewmodel.dart
        │   │
        │   ├── data/                      # Repository 패턴
        │   │   ├── user_repository.dart
        │   │   ├── post_repository.dart
        │   │   ├── place_repository.dart
        │   │   └── travel_plan_repository.dart
        │   │
        │   ├── services/
        │   │   └── api/
        │   │       └── tourism_api_service.dart  # 한국관광공사 TourAPI
        │   │
        │   ├── views/                     # UI 화면
        │   │   ├── home/home_page.dart    (707 LOC, 최대)
        │   │   ├── magazine/, concept/, popular/
        │   │   ├── login/, settings/
        │   │   └── test/
        │   │
        │   └── utils/
        │       └── firestore_user.dart    # ensureUserDoc()
        │
        ├── assets/{Dummy,Logo,Icon}/
        └── pubspec.yaml
```

---

## 🛠 기술 스택

| 영역 | 패키지 | 활용 |
|---|---|---|
| **Core** | Flutter ^3.x / Dart 3.x | Material Design 3 |
| **상태 관리** | provider ^6.1.5 | MultiProvider + ChangeNotifier |
| **인증** | firebase_core ^3.13, firebase_auth ^5.5, google_sign_in ^6.2 | Auth + Google Sign-In + AuthGate |
| **DB** | cloud_firestore ^5.4 | NoSQL, 실시간 동기화 |
| **HTTP** | http ^1.1 | TourAPI 호출 |
| **UI** | flutter_svg ^2.1, smooth_page_indicator ^1.2 | SVG 아이콘, 페이지 인디케이터 |
| **공유** | share_plus ^11.0 | OS 공유 |

---

## 🚀 시작하기

> ⚠️ 본 저장소에는 **Firebase 설정 파일 / TourAPI 키가 포함되어 있지 않습니다.**
> 자세한 셋업은 [SETUP.md](SETUP.md)를 참고하세요.

빠른 요약:
```bash
git clone https://github.com/jinho3501/Routour.git
cd Routour/routour1.0/routour
flutter pub get

# SETUP.md 1~2단계 (Firebase 설정 + TourAPI 키) 완료 후
flutter run --dart-define=TOUR_API_KEY=YOUR_KEY
```

---

## 📝 개발 일지 / 학습 노트

### Why RunInk 이후 Routour?
**RunInk(LG DX School 1기)** 에서 Flutter 30개 화면을 `setState`만으로 개발해본 후, 화면 간 prop drilling과 상태 동기화 이슈를 절감했습니다. Routour는 그 경험을 발판으로 **Provider + MVVM + Repository pattern**을 처음부터 도입한 후속 학습 프로젝트입니다.

### 적용한 패턴
1. **AuthGate** — `StreamBuilder<User?>`로 `authStateChanges()`를 구독해 로그인 상태에 따라 자동 화면 분기
2. **ensureUserDoc** — 로그인 직후 `users/{uid}` 문서를 1회만 생성/갱신 (포스트 프레임 콜백으로 build 중 setState 방지)
3. **DB code / UI label 분리** — 라벨 변경에도 DB 호환성 유지
4. **enum-driven domain** — 컴파일 타임 검증으로 잘못된 enum 값 차단

### 다음 학습 목표
- 추천 알고리즘: TourAPI 데이터 + 설문 결과 매칭
- Firestore 쿼리 최적화 + 캐싱 전략
- 위젯 테스트 + ViewModel 단위 테스트
- CI/CD (GitHub Actions + Codemagic)

---

## 🔗 관련 프로젝트

- 🏃 [**RunInk**](https://github.com/jinho3501/Runink) — LG DX School 1기 팀 프로젝트, Flutter + FastAPI 풀스택 GPS 아트 러닝 앱
- 🧠 [**ChuckChuck**](https://github.com/jinho3501/ChuckChuck) — iOS SwiftUI + Firebase 풀스택 (App Store 출시)
- 📑 [**Portfolio**](https://github.com/jinho3501/portfolio) — 진호 전체 포트폴리오 인덱스

---

## 📜 라이선스

본 프로젝트는 학습·포트폴리오 목적으로 공개됩니다.

---

<p align="center">
  <i>🚧 함께 진화하는 프로젝트입니다. 피드백 환영!</i>
</p>
