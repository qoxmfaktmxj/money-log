require "application_system_test_case"

class MoneyLogFlowTest < ApplicationSystemTestCase
  test "카테고리와 거래를 만들고 대시보드에서 확인한다" do
    travel_to Date.new(2026, 3, 14) do
      create_sample_data

      visit root_path
      click_on "분류"
      click_on "분류 추가"

      fill_in "분류 이름", with: "보너스"
      select "수입", from: "구분"
      click_on "저장하기"

      assert_text "분류를 저장했어요."
      assert_text "보너스"

      click_on "내역"
      click_on "내역 추가"
      select "수입", from: "구분"
      fill_in "금액", with: "500000"
      fill_in "날짜", with: "2026-03-14"
      select "보너스", from: "분류"
      fill_in "내용", with: "분기 성과급"
      click_on "저장하기"

      assert_text "내역을 저장했어요."
      assert_text "분기 성과급"

      visit root_path
      assert_text "₩3,500,000"

      click_on "내역"
      fill_in "내용 검색", with: "성과급"
      click_on "필터 적용"

      assert_text "분기 성과급"
      assert_no_text "점심 식사"
    end
  end
end
