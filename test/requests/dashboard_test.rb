require "test_helper"

class DashboardTest < ActionDispatch::IntegrationTest
  setup do
    create_sample_data
  end

  test "대시보드가 이번 달 합계를 보여준다" do
    travel_to Date.new(2026, 3, 14) do
      get root_path
    end

    assert_response :success
    assert_select "h1", "이번 달 요약"
    assert_match "₩3,000,000", response.body
    assert_match "₩15,500", response.body
    assert_match "₩2,984,500", response.body
    assert_match "식비", response.body
  end
end
