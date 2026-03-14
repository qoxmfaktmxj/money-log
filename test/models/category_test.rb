require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  setup do
    @categories, = create_sample_data
  end

  test "이름과 종류가 있으면 유효하다" do
    category = Category.new(name: "보너스", kind: "income")

    assert category.valid?
  end

  test "이름은 중복될 수 없다" do
    duplicate = Category.new(name: @categories[:salary].name, kind: "income")

    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "은 이미 사용 중입니다."
  end

  test "거래가 있으면 삭제할 수 없다" do
    category = @categories[:food]

    assert_not category.destroy
    assert_includes category.errors.full_messages, "이 분류에 연결된 내역이 있어 바로 지울 수 없습니다."
  end
end
