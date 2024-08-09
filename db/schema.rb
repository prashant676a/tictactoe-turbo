ActiveRecord::Schema[7.1].define(version: 2024_08_08_040118) do
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.json "state", null: false
    t.string "current_symbol", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "joiner_symbol"
    t.string "creator_symbol"
    t.integer "creator_id"
    t.integer "joiner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
