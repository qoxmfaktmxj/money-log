class Category < ApplicationRecord
  enum :kind, { income: "income", expense: "expense" }

  has_many :transactions

  before_destroy :ensure_no_transactions

  before_validation :normalize_name

  validates :name, presence: { message: "을 입력해주세요." },
                   uniqueness: { case_sensitive: false, message: "은 이미 사용 중입니다." },
                   length: { maximum: 50, message: "은 50자 이하로 입력해주세요." }
  validates :kind, presence: { message: "을 선택해주세요." },
                   inclusion: { in: kinds.keys, message: "이 올바르지 않습니다." }

  scope :sorted, -> { order(Arel.sql("CASE kind WHEN 'income' THEN 0 ELSE 1 END"), :name) }

  private

  def normalize_name
    self.name = name.to_s.strip.presence
  end

  def ensure_no_transactions
    return if transactions.none?

    errors.add(:base, "거래를 먼저 삭제해야 합니다.")
    throw :abort
  end
end
