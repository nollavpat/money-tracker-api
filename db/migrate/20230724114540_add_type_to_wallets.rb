class AddTypeToWallets < ActiveRecord::Migration[7.0]
  def change
    add_column :wallets, :direction, :integer, null: false
  end
end
