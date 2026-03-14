class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show edit update destroy]
  before_action :load_categories, only: %i[index new create edit update]

  def index
    @filters = filter_params.to_h.symbolize_keys
    @available_months = Transaction.available_months
    @transactions = Transaction.includes(:category).recent_first
    @transactions = @transactions.for_category(@filters[:category_id])
    @transactions = @transactions.for_kind(@filters[:kind])
    @transactions = @transactions.memo_contains(@filters[:query])

    apply_month_filter
    @transaction_count = @transactions.count
    @income_total = @transactions.income.sum(:amount)
    @expense_total = @transactions.expense.sum(:amount)
  end

  def show; end

  def new
    @transaction = Transaction.new(happened_on: Date.current)
  end

  def edit; end

  def create
    @transaction = Transaction.new(transaction_params)

    if @transaction.save
      redirect_to @transaction, success: "내역을 저장했어요."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to @transaction, success: "내역을 고쳤어요."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    redirect_to transactions_path, success: "내역을 삭제했어요."
  end

  private

  def set_transaction
    @transaction = Transaction.includes(:category).find(params[:id])
  end

  def load_categories
    @categories = Category.sorted
  end

  def filter_params
    params.permit(:month, :category_id, :kind, :query)
  end

  def transaction_params
    params.require(:transaction).permit(:kind, :amount, :happened_on, :category_id, :memo)
  end

  def apply_month_filter
    return if @filters[:month].blank?

    @transactions = @transactions.in_month(Date.strptime(@filters[:month], "%Y-%m"))
  rescue ArgumentError
    flash.now[:alert] = "월 필터는 YYYY-MM 형식이어야 합니다."
  end
end
