class CreateWallets < ActiveRecord::Migration[7.0]
  def change
    create_table :wallets do |t|
      t.string :name, null: false
      t.decimal :balance, null: false
      t.string :logo_url

      t.timestamps
    end
  end
end
