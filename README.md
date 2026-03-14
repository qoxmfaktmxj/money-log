# MoneyLog

MoneyLog은 초보자도 이해하기 쉬운 단일 사용자용 가계부 Rails 앱입니다. 로그인 없이 바로 사용할 수 있고, 월별 수입/지출 요약, 거래 관리, 카테고리 관리, 필터/검색을 기본 Rails MVC 방식으로 제공합니다.

## 구현 개요

- Rails 8.1.2
- Ruby 3.4.7
- SQLite
- 서버 렌더링 중심 UI
- 단일 사용자, 인증 없음
- 데모 시드 데이터 포함

### 아키텍처

- `DashboardController#show`: 이번 달 요약 카드, 최근 거래, 카테고리별 합계
- `TransactionsController`: 거래 CRUD, 월/카테고리/종류/메모 검색
- `CategoriesController`: 카테고리 CRUD, 카테고리별 상세 요약
- `Category`, `Transaction` 모델에 검증과 조회 스코프 집중

### 라우트 개요

| HTTP | Path | 설명 |
| --- | --- | --- |
| `GET` | `/` | 대시보드 |
| `GET` | `/transactions` | 거래 목록 + 필터/검색 |
| `GET` | `/transactions/new` | 거래 등록 |
| `POST` | `/transactions` | 거래 생성 |
| `GET` | `/transactions/:id` | 거래 상세 |
| `GET` | `/transactions/:id/edit` | 거래 수정 |
| `PATCH/PUT` | `/transactions/:id` | 거래 업데이트 |
| `DELETE` | `/transactions/:id` | 거래 삭제 |
| `GET` | `/categories` | 카테고리 목록 |
| `GET` | `/categories/new` | 카테고리 등록 |
| `POST` | `/categories` | 카테고리 생성 |
| `GET` | `/categories/:id` | 카테고리 상세 |
| `GET` | `/categories/:id/edit` | 카테고리 수정 |
| `PATCH/PUT` | `/categories/:id` | 카테고리 업데이트 |
| `DELETE` | `/categories/:id` | 카테고리 삭제 |
| `GET` | `/up` | Rails 헬스 체크 |

### 데이터 모델

#### categories

| 컬럼 | 타입 | 제약 |
| --- | --- | --- |
| `id` | integer | PK |
| `name` | string | 필수, 유니크 |
| `kind` | string | 필수, `income` or `expense` |
| `created_at` | datetime | 필수 |
| `updated_at` | datetime | 필수 |

#### transactions

| 컬럼 | 타입 | 제약 |
| --- | --- | --- |
| `id` | integer | PK |
| `kind` | string | 필수, `income` or `expense` |
| `amount` | decimal(12,2) | 필수, 0 초과 |
| `happened_on` | date | 필수 |
| `category_id` | integer | 필수, FK |
| `memo` | text | 선택, 최대 300자 |
| `created_at` | datetime | 필수 |
| `updated_at` | datetime | 필수 |

### 주요 디렉터리

```text
app/
  controllers/
    dashboard_controller.rb
    categories_controller.rb
    transactions_controller.rb
  models/
    category.rb
    transaction.rb
  views/
    dashboard/
    categories/
    transactions/
db/
  migrate/
  seeds.rb
test/
  models/
  requests/
  system/
config/
  routes.rb
  boot.rb
```

## 기능

- 이번 달 수입/지출/순잔액 카드
- 최근 거래 목록
- 이번 달 카테고리별 합계
- 거래 CRUD
- 카테고리 CRUD
- 거래 목록 필터
- 월
- 카테고리
- 종류
- 메모 검색
- 친절한 한국어 검증 오류
- 기본 스타일링
- 데모 시드 데이터

## 로컬 실행

### 사전 준비

- Ruby 3.4.7
- Bundler 4.0.3 이상
- SQLite 3

### 설치 및 실행 명령

```bash
bundle install
bin/rails db:setup
bin/rails server
```

브라우저에서 `http://localhost:3000`을 열면 됩니다.
처음 설치에는 `db:setup`을 쓰고, 이후에는 `bin/rails db:prepare` 또는 `ruby bin/setup`을 쓰는 편이 안전합니다.

### 테스트 명령

```bash
bin/rails test
```

### 초기화 포함 빠른 설정

```bash
ruby bin/setup
```

필요하면 아래처럼 초기화할 수 있습니다.

```bash
ruby bin/setup --reset --skip-server
```

### Windows 참고

RubyInstaller를 설치했지만 `ruby`나 `bundle`이 PATH에 없으면 설치 경로를 직접 지정해 실행할 수 있습니다.

```powershell
<RUBY_HOME>\bin\bundle.bat install
<RUBY_HOME>\bin\ruby.exe .\bin\rails db:setup
<RUBY_HOME>\bin\ruby.exe .\bin\rails test
<RUBY_HOME>\bin\ruby.exe .\bin\rails server
```

## Docker

간단한 로컬 실행용 Dockerfile을 포함했습니다.

```bash
docker build -t moneylog .
docker run --rm -p 3000:3000 moneylog
```

SQLite 파일은 컨테이너 내부에 저장됩니다. 데이터를 유지하려면 `storage/`를 볼륨으로 마운트하는 편이 좋습니다.

## 시드 데이터

`db/seeds.rb`는 다음 예시 데이터를 만듭니다.

- 수입 카테고리: 급여, 부업
- 지출 카테고리: 식비, 교통비, 생활용품
- 이번 달 거래와 지난달 거래 예시

`bin/rails db:setup` 또는 `bin/rails db:seed`로 불러올 수 있습니다.

## 테스트 범위

- 모델 테스트
- `Category`, `Transaction` 검증과 핵심 동작
- 요청 테스트
- 대시보드, 거래, 카테고리 주요 흐름
- 시스템 테스트
- 카테고리 생성 -> 거래 생성 -> 대시보드 확인 -> 필터 검색

## 가정과 트레이드오프

- 인증 없이 한 사람이 쓰는 앱으로 가정했습니다.
- 통계는 간단한 합계와 표 중심으로 구현했고 차트 라이브러리는 넣지 않았습니다.
- 카테고리 이름은 요구사항에 맞춰 전체에서 유니크하게 관리합니다.
- 거래가 연결된 카테고리는 바로 삭제하지 못하게 막았습니다.
- Rails는 최신 안정 버전인 8.1.2를 사용했습니다.
- Ruby는 이 저장소에서 3.4.7로 고정했습니다. Windows RubyInstaller 환경에서 Ruby 4.0.1과 Rails 8.1.2 조합이 부팅 중 절대 경로 glob 문제를 일으켜, 실제로 `db:setup`, `test`, `server` 검증이 가능한 안정 버전으로 맞췄습니다.
- 위 문제를 우회하기 위해 [config/boot.rb](/C:/Users/Administrator/Desktop/devdev/money-log/config/boot.rb)에 Windows 전용 glob 보정 코드를 넣었습니다. 이 파일은 이유 없이 제거하지 않는 편이 안전합니다.

## 검증 완료 항목

다음 명령을 실제로 실행해 확인했습니다.

```bash
MONEYLOG_DEVELOPMENT_DB=tmp/verify-development.sqlite3 MONEYLOG_TEST_DB=tmp/verify-test.sqlite3 bin/rails db:setup
bin/rails test
bin/rails server
```

## 주요 파일

- [config/routes.rb](/C:/Users/Administrator/Desktop/devdev/money-log/config/routes.rb)
- [app/controllers/dashboard_controller.rb](/C:/Users/Administrator/Desktop/devdev/money-log/app/controllers/dashboard_controller.rb)
- [app/controllers/transactions_controller.rb](/C:/Users/Administrator/Desktop/devdev/money-log/app/controllers/transactions_controller.rb)
- [app/controllers/categories_controller.rb](/C:/Users/Administrator/Desktop/devdev/money-log/app/controllers/categories_controller.rb)
- [app/models/transaction.rb](/C:/Users/Administrator/Desktop/devdev/money-log/app/models/transaction.rb)
- [app/models/category.rb](/C:/Users/Administrator/Desktop/devdev/money-log/app/models/category.rb)
- [db/seeds.rb](/C:/Users/Administrator/Desktop/devdev/money-log/db/seeds.rb)
- [test/system/money_log_flow_test.rb](/C:/Users/Administrator/Desktop/devdev/money-log/test/system/money_log_flow_test.rb)
- [config/boot.rb](/C:/Users/Administrator/Desktop/devdev/money-log/config/boot.rb)
