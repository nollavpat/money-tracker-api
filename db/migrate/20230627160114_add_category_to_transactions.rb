class AddCategoryToTransactions < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :category, :integer, null: false
  end
end
