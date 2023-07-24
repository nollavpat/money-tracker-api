class CreatePaymentTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_transactions do |t|
      t.references :expense, null: false, foreign_key: { to_table: :txns }
      t.references :payment, null: false, foreign_key: { to_table: :txns }

      t.timestamps
    end

    add_index :payment_transactions, [:expense_id, :payment_id], unique: true
  end
end
