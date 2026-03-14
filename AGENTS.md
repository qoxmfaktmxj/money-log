# AGENTS.md

이 저장소에서 작업할 때는 아래 규칙을 우선합니다.

## 기본 원칙

- 항상 한국어로 설명한다.
- 먼저 현재 코드, 실행 흐름, 테스트 상태를 확인하고 추측하지 않는다.
- 변경은 가능한 한 작게 한다.
- 요청과 직접 관련 없는 리팩터링은 하지 않는다.
- 기본 Rails MVC 구조를 유지한다.
- 서버 렌더링을 우선하고, Hotwire나 추가 JS는 꼭 필요할 때만 쓴다.

## 기술 기준

- Ruby 3.4.7
- Rails 8.1.2
- SQLite
- 단일 사용자, 인증 없음

## 앱 구조 메모

- 대시보드: `DashboardController#show`
- 거래 관리: `TransactionsController`
- 카테고리 관리: `CategoriesController`
- 핵심 비즈니스 규칙은 `Category`, `Transaction` 모델에 둔다.
- 복잡한 서비스 객체는 정말 읽기 쉬워질 때만 추가한다.

## 검증 규칙

- 모델이나 컨트롤러를 바꾸면 기본적으로 `bin/rails test`를 다시 실행한다.
- UI 흐름이 바뀌면 시스템 테스트 보강 또는 실행을 우선한다.
- 가능하면 `bin/rails db:setup`과 `bin/rails server` 부팅도 확인한다.

## 데이터/도메인 규칙

- `Category.name`은 전체에서 유니크하다.
- `Category.kind`와 `Transaction.kind`는 `income`, `expense`만 허용한다.
- 거래의 카테고리 종류와 거래 종류는 반드시 같아야 한다.
- 거래가 연결된 카테고리는 삭제하지 않는다.
- 대시보드 합계는 항상 현재 달 기준이다.

## 테스트 메모

- 테스트는 fixture보다 `test/test_helper.rb`의 `FinanceTestData` 헬퍼를 사용한다.
- 시스템 테스트는 rack_test 기반이다.

## Windows 주의사항

- [config/boot.rb](/C:/Users/Administrator/Desktop/devdev/money-log/config/boot.rb)에 Windows 절대 경로 glob 보정 코드가 있다.
- 이 코드는 Rails 8.1.2를 Windows RubyInstaller 환경에서 안정적으로 부팅시키기 위한 우회다.
- 이유를 확인하지 않고 제거하거나 단순화하지 않는다.

## 문서화 규칙

- 실행 방법이 바뀌면 [README.md](/C:/Users/Administrator/Desktop/devdev/money-log/README.md)도 같이 갱신한다.
- Ruby/Rails 버전 변경이나 환경 제약이 생기면 README와 AGENTS.md에 함께 기록한다.
