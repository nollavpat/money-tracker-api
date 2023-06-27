class AddDirectionToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :direction, :integer, null: false
  end
end
