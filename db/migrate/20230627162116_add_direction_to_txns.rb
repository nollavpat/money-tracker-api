class AddDirectionToTxns < ActiveRecord::Migration[7.0]
  def change
    add_column :txns, :direction, :integer, null: false
  end
end
