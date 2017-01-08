# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170104202220) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.string   "body",       null: false
    t.integer  "meetup_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "meetups", force: :cascade do |t|
    t.integer "creator_id",  null: false
    t.string  "name",        null: false
    t.string  "description", null: false
    t.string  "location",    null: false
  end

  create_table "signups", force: :cascade do |t|
    t.integer  "meetup_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meetup_id"], name: "index_signups_on_meetup_id", using: :btree
    t.index ["user_id"], name: "index_signups_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider",   null: false
    t.string   "uid",        null: false
    t.string   "username",   null: false
    t.string   "email",      null: false
    t.string   "avatar_url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true, using: :btree
  end

end