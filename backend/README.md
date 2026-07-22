# Routour Backend (FastAPI + PostgreSQL + Redis)

Flutter 앱과 Postgres/Redis 사이의 API 레이어. 로그인/회원가입은 여전히 Firebase Auth가 담당하고,
이 서버는 Flutter가 보낸 Firebase ID 토큰을 검증한 뒤 나머지 데이터(Postgres)와 캐시(Redis)를 다룬다.

## 로컬 실행

```bash
cd backend
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt

cp .env.example .env
# .env에서 FIREBASE_SERVICE_ACCOUNT_PATH가 가리키는 위치에
# Firebase Console > 프로젝트 설정 > 서비스 계정 > 새 비공개 키 생성 으로 받은 JSON을 둔다.

docker compose up -d          # Postgres + Redis 컨테이너 기동
alembic upgrade head          # users 테이블 생성

uvicorn app.main:app --reload --port 8000
```

`http://localhost:8000/docs`에서 Swagger UI 확인 가능.

## 구조

```
app/
├── main.py              # FastAPI 앱 진입점
├── core/
│   ├── config.py         # 환경변수 설정 (pydantic-settings)
│   └── security.py       # Firebase ID 토큰 검증 dependency
├── db/session.py          # SQLAlchemy engine/session
├── models/user.py         # Postgres users 테이블
├── schemas/user.py        # 요청/응답 pydantic 모델
├── api/routes/users.py    # /users/me 등 엔드포인트
└── cache/redis_client.py  # Redis 연결 + TourAPI 캐싱 헬퍼
alembic/                  # DB 마이그레이션
```

## Flutter 쪽 연동 방식

각 요청에 Firebase ID 토큰을 실어 보낸다:

```dart
final token = await FirebaseAuth.instance.currentUser?.getIdToken();
final res = await http.get(
  Uri.parse('http://<서버주소>/users/me'),
  headers: {'Authorization': 'Bearer $token'},
);
```

로그인/회원가입 직후에는 `POST /users/me/login-sync`를 호출해 Postgres에 유저 row를 만들거나
`last_login_at`을 갱신한다 (기존 `_ensureUserDoc()`과 같은 역할).

## 아직 안 된 것 / 다음 단계

- TourAPI 프록시 엔드포인트 (Redis 캐싱 적용) — `cache/redis_client.py`의 헬퍼는 준비돼 있으나
  실제 라우트는 아직 없음
- travel_plan / survey 관련 테이블·엔드포인트 (Flutter 쪽에 아직 해당 모델이 없어서 보류)
- 배포 환경 설정 (지금은 로컬 개발용 docker-compose만 있음)
