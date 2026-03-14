module ApplicationHelper
  def app_title(page_title = nil)
    [page_title, "MoneyLog"].compact.join(" | ")
  end

  def money(amount)
    value = amount.to_d
    precision = value.frac.zero? ? 0 : 2

    number_to_currency(value, unit: "₩", precision: precision, delimiter: ",", format: "%u%n")
  end

  def kind_name(kind)
    kind.to_s == "income" ? "수입" : "지출"
  end

  def kind_badge_class(kind)
    "badge badge-#{kind}"
  end

  def amount_class(kind)
    kind.to_s == "income" ? "money money-income" : "money money-expense"
  end

  def month_label(date)
    l(date, format: :month)
  end
end
