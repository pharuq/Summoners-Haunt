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

ActiveRecord::Schema.define(version: 20171228063119) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "adminpack"

  create_table "communities", force: :cascade do |t|
    t.string "name"
    t.text "content"
    t.string "picture"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_communities_on_user_id"
  end

  create_table "community_comments", force: :cascade do |t|
    t.bigint "community_topic_id"
    t.bigint "user_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "community_id"
    t.index ["community_id"], name: "index_community_comments_on_community_id"
    t.index ["community_topic_id", "created_at"], name: "index_community_comments_on_community_topic_id_and_created_at"
    t.index ["community_topic_id"], name: "index_community_comments_on_community_topic_id"
    t.index ["user_id"], name: "index_community_comments_on_user_id"
  end

  create_table "community_topics", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "user_id"
    t.bigint "community_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_community_topics_on_community_id"
    t.index ["user_id"], name: "index_community_topics_on_user_id"
  end

  create_table "communityships", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "community_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_communityships_on_community_id"
    t.index ["user_id", "community_id"], name: "index_communityships_on_user_id_and_community_id", unique: true
    t.index ["user_id"], name: "index_communityships_on_user_id"
  end

  create_table "diaries", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shared_with", default: 0
    t.json "pictures"
    t.index ["user_id", "created_at"], name: "index_diaries_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_diaries_on_user_id"
  end

  create_table "diary_comments", force: :cascade do |t|
    t.bigint "diary_id"
    t.bigint "user_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["diary_id", "created_at"], name: "index_diary_comments_on_diary_id_and_created_at"
    t.index ["diary_id"], name: "index_diary_comments_on_diary_id"
    t.index ["user_id"], name: "index_diary_comments_on_user_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer "from_user_id"
    t.integer "to_user_id"
    t.boolean "activated", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id", "to_user_id"], name: "index_friendships_on_from_user_id_and_to_user_id", unique: true
    t.index ["from_user_id"], name: "index_friendships_on_from_user_id"
    t.index ["to_user_id"], name: "index_friendships_on_to_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "content"
    t.integer "from_user_id"
    t.integer "to_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read", default: false
    t.index ["from_user_id", "to_user_id", "created_at"], name: "index_messages_on_from_user_id_and_to_user_id_and_created_at"
    t.index ["from_user_id"], name: "index_messages_on_from_user_id"
    t.index ["to_user_id"], name: "index_messages_on_to_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "role"
    t.text "profile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_send_at"
    t.string "picture"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "communities", "users"
  add_foreign_key "community_comments", "communities"
  add_foreign_key "community_comments", "community_topics"
  add_foreign_key "community_comments", "users"
  add_foreign_key "community_topics", "communities"
  add_foreign_key "community_topics", "users"
  add_foreign_key "communityships", "communities"
  add_foreign_key "communityships", "users"
  add_foreign_key "diaries", "users"
  add_foreign_key "diary_comments", "diaries"
  add_foreign_key "diary_comments", "users"
end
