class RemoveDirectionFromTxns < ActiveRecord::Migration[7.0]
  def change
    remove_column :txns, :direction
  end
end
