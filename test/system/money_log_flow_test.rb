require "application_system_test_case"

class MoneyLogFlowTest < ApplicationSystemTestCase
  test "카테고리와 거래를 만들고 대시보드에서 확인한다" do
    travel_to Date.new(2026, 3, 14) do
      create_sample_data

      visit root_path
      click_on "카테고리"
      click_on "새 카테고리"

      fill_in "이름", with: "보너스"
      select "수입", from: "종류"
      click_on "카테고리 만들기"

      assert_text "카테고리를 등록했습니다."
      assert_text "보너스"

      click_on "거래 내역"
      click_on "새 거래"
      select "수입", from: "종류"
      fill_in "금액", with: "500000"
      fill_in "거래일", with: "2026-03-14"
      select "수입 · 보너스", from: "카테고리"
      fill_in "메모", with: "분기 성과급"
      click_on "거래 만들기"

      assert_text "거래를 등록했습니다."
      assert_text "분기 성과급"

      visit root_path
      assert_text "₩3,500,000"

      click_on "거래 내역"
      fill_in "메모 검색", with: "성과급"
      click_on "필터 적용"

      assert_text "분기 성과급"
      assert_no_text "점심 식사"
    end
  end
end
