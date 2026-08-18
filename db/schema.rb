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

ActiveRecord::Schema[8.1].define(version: 2026_08_18_223758) do
  create_table "shifts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "ends_at", null: false
    t.datetime "starts_at", null: false
    t.integer "team_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["starts_at"], name: "index_shifts_on_starts_at"
    t.index ["team_id"], name: "index_shifts_on_team_id"
    t.index ["user_id"], name: "index_shifts_on_user_id"
  end

  create_table "swap_requests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "requesting_user_id", null: false
    t.integer "shift_id", null: false
    t.string "status", default: "pending", null: false
    t.integer "target_user_id", null: false
    t.datetime "updated_at", null: false
    t.index ["requesting_user_id"], name: "index_swap_requests_on_requesting_user_id"
    t.index ["shift_id"], name: "index_swap_requests_on_shift_id"
    t.index ["status"], name: "index_swap_requests_on_status"
    t.index ["target_user_id"], name: "index_swap_requests_on_target_user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.boolean "manager", default: false, null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  add_foreign_key "shifts", "teams"
  add_foreign_key "shifts", "users"
  add_foreign_key "swap_requests", "shifts"
  add_foreign_key "swap_requests", "users", column: "requesting_user_id"
  add_foreign_key "swap_requests", "users", column: "target_user_id"
  add_foreign_key "users", "teams"
end
