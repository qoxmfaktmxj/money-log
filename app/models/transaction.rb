class Transaction < ApplicationRecord
  enum :kind, { income: "income", expense: "expense" }

  belongs_to :category

  before_validation :normalize_memo

  validates :kind, presence: { message: "을 선택해주세요." },
                   inclusion: { in: kinds.keys, message: "이 올바르지 않습니다." }
  validates :amount, presence: { message: "을 입력해주세요." },
                     numericality: { greater_than: 0, message: "은 0보다 커야 합니다." }
  validates :happened_on, presence: { message: "을 입력해주세요." }
  validates :category, presence: { message: "를 선택해주세요." }
  validates :memo, length: { maximum: 300, message: "는 300자 이하로 입력해주세요." }, allow_blank: true

  validate :category_kind_matches_transaction_kind

  scope :recent_first, -> { order(happened_on: :desc, created_at: :desc) }
  scope :in_month, ->(date) { where(happened_on: date.beginning_of_month..date.end_of_month) }
  scope :for_category, ->(category_id) { category_id.present? ? where(category_id: category_id) : all }
  scope :for_kind, ->(kind) { kind.present? ? where(kind: kind) : all }
  scope :memo_contains, lambda { |query|
    query.present? ? where("LOWER(COALESCE(memo, '')) LIKE ?", "%#{sanitize_sql_like(query.downcase)}%") : all
  }

  def self.current_month(reference_date = Date.current)
    in_month(reference_date)
  end

  def self.available_months
    order(happened_on: :desc).pluck(:happened_on).map { |date| date.strftime("%Y-%m") }.uniq
  end

  private

  def normalize_memo
    self.memo = memo.to_s.strip.presence
  end

  def category_kind_matches_transaction_kind
    return if category.blank? || kind.blank?
    return if category.kind == kind

    errors.add(:base, "카테고리 종류와 거래 종류는 같아야 합니다.")
  end
end
