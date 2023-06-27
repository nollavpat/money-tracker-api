class AddCategoryToTxns < ActiveRecord::Migration[7.0]
  def change
    add_column :txns, :category, :integer, null: false
  end
end
