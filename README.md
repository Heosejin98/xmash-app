# xmash_app

```
lib/
├── core/
│   ├── constants/              # 상수 값들
│   │   ├── app_constants.dart
│   │   └── theme_constants.dart
│   ├── errors/                 # 에러 처리
│   │   └── failures.dart
│   └── utils/                  # 유틸리티 함수들
│       └── helpers.dart
│
├── data/
│   ├── datasources/            # 데이터 소스 (API, 로컬DB 등)
│   │   ├── local/
│   │   └── remote/
│   ├── models/                 # 데이터 모델
│   │   └── match_model.dart
│   └── repositories/           # 레포지토리 구현
│       └── match_repository_impl.dart
│
├── domain/
│   ├── entities/               # 비즈니스 엔티티
│   │   └── match.dart
│   ├── repositories/           # 레포지토리 인터페이스
│   │   └── match_repository.dart
│   └── usecases/              # 유즈케이스
│       └── get_matches.dart
│
├── presentation/
│   ├── screens/               # 화면
│   │   ├── home/
│   │   └── match_list/
│   ├── widgets/               # 재사용 가능한 위젯
│   │   ├── common/
│   │   └── match_list/
│   └── providers/            # 상태 관리 (Provider, Bloc 등)
│       └── match_provider.dart
│
├── config/                   # 환경설정
│   ├── routes/              # 라우트 설정
│   │   └── app_routes.dart
│   └── themes/              # 테마 설정
│       └── app_theme.dart
│
└── main.dart
```


### 1. core/
앱 전체에서 사용되는 공통 기능들
상수, 유틸리티 함수, 공통 위젯 등
### 2. data/ 
외부 데이터 처리 관련 코드
API 통신, 로컬 데이터베이스 등
데이터 모델과 레포지토리 구현
#### 3. domain/ (외부 의존성이 없어야함)
비즈니스 로직
엔티티(비즈니스 객체)
레포지토리 인터페이스
유즈케이스
### 4. presentation/
UI 관련 코드
화면, 위젯
상태 관리
### 5. config/
앱 설정 관련
라우트, 테마 등