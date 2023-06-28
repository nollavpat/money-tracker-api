class CreateTxns < ActiveRecord::Migration[7.0]
  def change
    create_table :txns do |t|
      t.decimal :amount, null: false
      t.string :name, null: false
      t.references :purpose, null: false, foreign_key: true
      t.references :wallet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
