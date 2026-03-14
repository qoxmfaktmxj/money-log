module ApplicationHelper
  def app_name
    "살림기록"
  end

  def app_title(page_title = nil)
    [page_title, app_name].compact.join(" | ")
  end

  def money(amount)
    value = amount.to_d
    precision = value.frac.zero? ? 0 : 2

    number_to_currency(value, unit: "₩", precision: precision, delimiter: ",", format: "%u%n")
  end

  def kind_name(kind)
    kind.to_s == "income" ? "수입" : "지출"
  end

  def grouped_categories_for_select(categories)
    {
      "수입 분류" => categories.select(&:income?).map { |category| [category.name, category.id] },
      "지출 분류" => categories.select(&:expense?).map { |category| [category.name, category.id] }
    }.reject { |_label, items| items.empty? }
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

  def category_bar_width(total, max_total)
    return 0 if max_total.to_d <= 0

    [(total.to_d / max_total.to_d * 100).round, 12].max
  end
end
