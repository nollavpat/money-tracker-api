class CreatePaymentTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_transactions do |t|
      t.references :expense, null: false, foreign_key: { to_table: :txns }, index: { unique: true }
      t.references :payment, null: false, foreign_key: { to_table: :txns }

      t.timestamps
    end
  end
end
