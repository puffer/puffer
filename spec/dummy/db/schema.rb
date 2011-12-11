# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111208222355) do

  create_table "active_record_orm_has_many_references", :force => true do |t|
    t.string   "name"
    t.integer  "primal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "active_record_orm_has_one_references", :force => true do |t|
    t.string   "name"
    t.integer  "primal_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "active_record_orm_primals", :force => true do |t|
    t.string   "string_field"
    t.text     "text_field"
    t.string   "select_field"
    t.integer  "integer_field"
    t.float    "float_field"
    t.decimal  "decimal_field"
    t.datetime "datetime_field"
    t.datetime "timestamp_field"
    t.time     "time_field"
    t.date     "date_field"
    t.boolean  "boolean_field"
  end

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.boolean  "hidden"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clearance_users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password", :limit => 128
    t.string   "salt",               :limit => 128
    t.string   "confirmation_token", :limit => 128
    t.string   "remember_token",     :limit => 128
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_categories", :force => true do |t|
    t.integer  "post_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.string   "status"
    t.string   "filename"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "surname"
    t.date     "birth_date"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "puffer_users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "roles"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.string  "name"
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string  "taggable_type"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
