# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100305132905) do

  create_table "feedbacks", :force => true do |t|
    t.string   "email"
    t.string   "body",           :null => false
    t.string   "submission_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "games", :force => true do |t|
    t.float    "avg_rating",        :default => 0.0
    t.integer  "num_ratings",       :default => 0
    t.float    "ranked_value",      :default => 0.0
    t.boolean  "deleted",           :default => false
    t.integer  "play_count",        :default => 0
    t.boolean  "removed",           :default => false
    t.string   "platform",          :default => "NES", :null => false
    t.string   "storage_object_id",                    :null => false
    t.text     "description"
    t.string   "title"
    t.boolean  "is_adult",          :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "thumbnail_id"
    t.string   "original_filename"
    t.boolean  "is_uploaded",       :default => false
    t.boolean  "generated_thumbs",  :default => false
  end

  add_index "games", ["storage_object_id"], :name => "index_games_on_storage_object_id"

  create_table "ratings", :force => true do |t|
    t.integer  "rating",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "game_id"
  end

  create_table "thumbnails", :force => true do |t|
    t.string   "storage_object_id", :null => false
    t.integer  "width",             :null => false
    t.integer  "height",            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.string   "original_filename"
  end

  create_table "userPhotos", :force => true do |t|
    t.integer "user_id"
    t.string  "storage_object_id", :null => false
    t.string  "original_filename", :null => false
    t.integer "width",             :null => false
    t.integer "height",            :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "about"
    t.string   "name"
    t.date     "expiration"
    t.integer  "userPhoto_id"
  end

  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end
