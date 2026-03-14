class DashboardController < ApplicationController
  def show
    monthly_transactions = Transaction.current_month.includes(:category)

    @current_month = Date.current.beginning_of_month
    @income_total = monthly_transactions.income.sum(:amount)
    @expense_total = monthly_transactions.expense.sum(:amount)
    @net_balance = @income_total - @expense_total
    @recent_transactions = Transaction.includes(:category).recent_first.limit(8)
    @category_totals = monthly_transactions.joins(:category)
                                        .group("categories.id", "categories.name", "categories.kind")
                                        .sum(:amount)
                                        .map do |(id, name, kind), total|
      { id: id, name: name, kind: kind, total: total }
    end.sort_by { |row| [row[:kind] == "income" ? 0 : 1, -row[:total].to_d] }
  end
end
