class CreateTagAndTxns < ActiveRecord::Migration[7.0]
  def change
    create_table :tag_txns do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :txn, null: false, foreign_key: true
    end
  end
end
