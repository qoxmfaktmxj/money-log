require "test_helper"

class TransactionsTest < ActionDispatch::IntegrationTest
  setup do
    @categories, @transactions = create_sample_data
  end

  test "거래를 만들 수 있다" do
    assert_difference("Transaction.count", 1) do
      post transactions_path, params: {
        transaction: {
          kind: "expense",
          amount: 4500,
          happened_on: "2026-03-08",
          category_id: @categories[:transport].id,
          memo: "지하철 환승"
        }
      }
    end

    assert_redirected_to transaction_path(Transaction.order(:id).last)
  end

  test "거래를 수정할 수 있다" do
    patch transaction_path(@transactions[:lunch_march]), params: {
      transaction: {
        kind: "expense",
        amount: 15000,
        happened_on: "2026-03-05",
        category_id: @categories[:food].id,
        memo: "점심 식사와 커피"
      }
    }

    assert_redirected_to transaction_path(@transactions[:lunch_march])
    assert_equal 15000, @transactions[:lunch_march].reload.amount.to_i
  end

  test "필터와 검색이 동작한다" do
    get transactions_path, params: { month: "2026-03", kind: "expense", category_id: @categories[:food].id, query: "점심" }

    assert_response :success
    assert_match "점심 식사", response.body
    assert_no_match "버스 충전", response.body
    assert_no_match "지난달 원고료", response.body
  end

  test "거래를 삭제할 수 있다" do
    assert_difference("Transaction.count", -1) do
      delete transaction_path(@transactions[:bus_march])
    end

    assert_redirected_to transactions_path
  end
end
