# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_27_162116) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "purposes", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.string "amount", null: false
    t.string "name", null: false
    t.bigint "purpose_id", null: false
    t.bigint "wallet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category", null: false
    t.integer "direction", null: false
    t.index ["purpose_id"], name: "index_transactions_on_purpose_id"
    t.index ["wallet_id"], name: "index_transactions_on_wallet_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "balance", null: false
    t.string "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "transactions", "purposes"
  add_foreign_key "transactions", "wallets"
end
