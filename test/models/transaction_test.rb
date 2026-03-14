require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  setup do
    @categories, @transactions = create_sample_data
  end

  test "금액은 0보다 커야 한다" do
    transaction = Transaction.new(kind: "expense", amount: 0, happened_on: Date.current, category: @categories[:food])

    assert_not transaction.valid?
    assert_includes transaction.errors[:amount], "은 0보다 커야 합니다."
  end

  test "카테고리 종류와 거래 종류가 다르면 유효하지 않다" do
    transaction = Transaction.new(kind: "income", amount: 10_000, happened_on: Date.current, category: @categories[:food])

    assert_not transaction.valid?
    assert_includes transaction.errors[:base], "분류 구분과 내역 구분은 같아야 합니다."
  end

  test "월 필터와 메모 검색이 동작한다" do
    results = Transaction.in_month(Date.new(2026, 3, 1)).memo_contains("점심")

    assert_equal [@transactions[:lunch_march]], results.to_a
  end
end
