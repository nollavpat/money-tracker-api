class RemoveBalanceFromWallets < ActiveRecord::Migration[7.0]
  def change
    remove_column :wallets, :balance
  end
end
