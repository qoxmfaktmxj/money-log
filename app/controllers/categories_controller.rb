class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]

  def index
    @categories = Category.includes(:transactions).sorted
  end

  def show
    @recent_transactions = @category.transactions.includes(:category).recent_first.limit(10)
    @total_amount = @category.transactions.sum(:amount)
    @current_month_total = @category.transactions.in_month(Date.current).sum(:amount)
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to @category, success: "카테고리를 등록했습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to @category, success: "카테고리를 수정했습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      redirect_to categories_path, success: "카테고리를 삭제했습니다."
    else
      redirect_to categories_path, alert: @category.errors.full_messages.to_sentence
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :kind)
  end
end
