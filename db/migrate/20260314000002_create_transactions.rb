class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.string :kind, null: false
      t.decimal :amount, precision: 12, scale: 2, null: false
      t.date :happened_on, null: false
      t.references :category, null: false, foreign_key: true
      t.text :memo

      t.timestamps
    end

    add_index :transactions, :happened_on
    add_index :transactions, :kind
  end
end
