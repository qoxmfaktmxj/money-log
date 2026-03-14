require "test_helper"

class CategoriesTest < ActionDispatch::IntegrationTest
  setup do
    @categories, = create_sample_data
  end

  test "카테고리를 만들 수 있다" do
    assert_difference("Category.count", 1) do
      post categories_path, params: { category: { name: "문화생활", kind: "expense" } }
    end

    assert_redirected_to category_path(Category.order(:id).last)
  end

  test "카테고리를 수정할 수 있다" do
    patch category_path(@categories[:food]), params: { category: { name: "외식비", kind: "expense" } }

    assert_redirected_to category_path(@categories[:food])
    assert_equal "외식비", @categories[:food].reload.name
  end

  test "거래가 연결된 카테고리는 삭제되지 않는다" do
    assert_no_difference("Category.count") do
      delete category_path(@categories[:food])
    end

    assert_redirected_to categories_path
  end
end
