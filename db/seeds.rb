# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
salary = Category.find_or_create_by!(name: "급여") { |category| category.kind = "income" }
freelance = Category.find_or_create_by!(name: "부업") { |category| category.kind = "income" }
food = Category.find_or_create_by!(name: "식비") { |category| category.kind = "expense" }
transport = Category.find_or_create_by!(name: "교통비") { |category| category.kind = "expense" }
living = Category.find_or_create_by!(name: "생활용품") { |category| category.kind = "expense" }

demo_transactions = [
  { kind: "income", amount: 3_000_000, happened_on: Date.current.beginning_of_month + 1.day, category: salary, memo: "월급 입금" },
  { kind: "income", amount: 450_000, happened_on: Date.current.beginning_of_month + 6.days, category: freelance, memo: "주말 프로젝트 정산" },
  { kind: "expense", amount: 13_500, happened_on: Date.current.beginning_of_month + 2.days, category: food, memo: "점심 도시락" },
  { kind: "expense", amount: 56_000, happened_on: Date.current.beginning_of_month + 4.days, category: living, memo: "세제와 휴지 구매" },
  { kind: "expense", amount: 3_800, happened_on: Date.current.beginning_of_month + 5.days, category: transport, memo: "버스 충전" },
  { kind: "expense", amount: 18_000, happened_on: Date.current.beginning_of_month + 9.days, category: food, memo: "저녁 약속" },
  { kind: "income", amount: 700_000, happened_on: Date.current.prev_month.beginning_of_month + 10.days, category: freelance, memo: "지난달 원고료" }
]

demo_transactions.each do |attributes|
  Transaction.find_or_create_by!(attributes)
end

puts "카테고리 #{Category.count}개, 거래 #{Transaction.count}개를 준비했습니다."
