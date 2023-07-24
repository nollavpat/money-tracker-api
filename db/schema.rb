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

ActiveRecord::Schema[7.0].define(version: 2023_07_24_114540) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "purposes", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tag_txns", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "txn_id", null: false
    t.index ["tag_id", "txn_id"], name: "index_tag_txns_on_tag_id_and_txn_id", unique: true
    t.index ["tag_id"], name: "index_tag_txns_on_tag_id"
    t.index ["txn_id"], name: "index_tag_txns_on_txn_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "txns", force: :cascade do |t|
    t.decimal "amount", null: false
    t.string "name", null: false
    t.bigint "purpose_id", null: false
    t.bigint "wallet_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category", null: false
    t.index ["purpose_id"], name: "index_txns_on_purpose_id"
    t.index ["wallet_id"], name: "index_txns_on_wallet_id"
  end

  create_table "wallets", force: :cascade do |t|
    t.string "name", null: false
    t.string "logo_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "direction", null: false
  end

  add_foreign_key "tag_txns", "tags"
  add_foreign_key "tag_txns", "txns"
  add_foreign_key "txns", "purposes"
  add_foreign_key "txns", "wallets"
end
