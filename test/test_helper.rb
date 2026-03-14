ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module FinanceTestData
  def create_sample_data
    categories = {
      salary: Category.create!(name: "급여", kind: "income"),
      freelance: Category.create!(name: "부업", kind: "income"),
      food: Category.create!(name: "식비", kind: "expense"),
      transport: Category.create!(name: "교통비", kind: "expense")
    }

    transactions = {
      salary_march: Transaction.create!(kind: "income", amount: 3_000_000, happened_on: Date.new(2026, 3, 3), category: categories[:salary], memo: "3월 급여"),
      lunch_march: Transaction.create!(kind: "expense", amount: 12_000, happened_on: Date.new(2026, 3, 5), category: categories[:food], memo: "점심 식사"),
      bus_march: Transaction.create!(kind: "expense", amount: 3_500, happened_on: Date.new(2026, 3, 6), category: categories[:transport], memo: "버스 충전"),
      freelance_february: Transaction.create!(kind: "income", amount: 800_000, happened_on: Date.new(2026, 2, 10), category: categories[:freelance], memo: "지난달 원고료")
    }

    [categories, transactions]
  end
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Add more helper methods to be used by all tests here...
    include ActiveSupport::Testing::TimeHelpers
    include FinanceTestData
  end
end
