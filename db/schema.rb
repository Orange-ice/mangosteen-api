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

ActiveRecord::Schema[7.0].define(version: 2022_08_07_115341) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bills", force: :cascade do |t|
    t.integer "amount"
    t.integer "tag_id"
    t.integer "user_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 1, null: false
    t.datetime "happened_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", limit: 64, null: false
    t.string "sign", limit: 64, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 64
    t.string "name", limit: 16
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "validate_codes", force: :cascade do |t|
    t.string "email", limit: 64
    t.string "code", limit: 64
    t.datetime "used_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
