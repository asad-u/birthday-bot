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

ActiveRecord::Schema.define(version: 2021_05_05_114151) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "birthdays", force: :cascade do |t|
    t.date "date"
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_birthdays_on_organization_id"
    t.index ["user_id"], name: "index_birthdays_on_user_id"
  end

  create_table "bots", force: :cascade do |t|
    t.string "bot_id"
    t.string "source"
    t.string "channel_name"
    t.string "channel_id"
    t.string "webhook_configuration_url"
    t.string "webhook_url"
    t.bigint "organization_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "status", default: "installed"
    t.text "access_token_ciphertext"
    t.index ["organization_id"], name: "index_bots_on_organization_id"
  end

  create_table "organization_users", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "organization_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_organization_users_on_organization_id"
    t.index ["user_id"], name: "index_organization_users_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "slack_id"
    t.string "domain"
    t.string "logo"
    t.bigint "primary_contact_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "full_name"
    t.string "slack_id"
    t.string "image_url"
  end

  add_foreign_key "birthdays", "organizations"
  add_foreign_key "birthdays", "users"
end
