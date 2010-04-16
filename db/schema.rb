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

ActiveRecord::Schema.define(:version => 20100327135547) do

  create_table "feedbacks", :force => true do |t|
    t.string   "email"
    t.text     "body",           :null => false
    t.string   "submission_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "games", :force => true do |t|
    t.float    "avg_rating",                  :default => 0.0,   :null => false
    t.integer  "num_ratings",                 :default => 0,     :null => false
    t.float    "ranked_value",                :default => 0.0,   :null => false
    t.boolean  "deleted",                     :default => false, :null => false
    t.boolean  "received_dmca_takedown",      :default => false, :null => false
    t.integer  "play_count",                  :default => 0,     :null => false
    t.string   "platform",                    :default => "NES", :null => false
    t.text     "description"
    t.string   "title"
    t.string   "storage_object_id",                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "user_has_selected_thumbnail", :default => false, :null => false
    t.boolean  "file_uploaded",               :default => false, :null => false
    t.boolean  "file_processed",              :default => false, :null => false
    t.boolean  "file_published",              :default => false, :null => false
    t.integer  "user_id"
    t.integer  "thumbnail_id"
    t.string   "original_filename"
  end

  create_table "profilePhotos", :force => true do |t|
    t.integer "user_id"
    t.string  "storage_object_id", :null => false
    t.string  "original_filename", :null => false
    t.integer "width",             :null => false
    t.integer "height",            :null => false
  end

  create_table "ratings", :force => true do |t|
    t.integer  "rating",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "game_id"
  end

  create_table "rewards", :force => true do |t|
    t.integer "num_bug_cookies_hidden",      :default => 0
    t.integer "num_bug_cookies_visible",     :default => 0
    t.integer "num_users_recruited_hidden",  :default => 0
    t.integer "num_users_recruited_visible", :default => 0
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

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "single_access_token"
    t.string   "perishable_token"
    t.integer  "login_count",          :default => 0,     :null => false
    t.integer  "failed_login_count",   :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.text     "about"
    t.string   "name"
    t.string   "facebook_id"
    t.string   "facebook_session_key"
    t.boolean  "facebook_new_user",    :default => false, :null => false
    t.boolean  "use_our_photo",        :default => false, :null => false
    t.integer  "profilePhoto_id"
    t.integer  "reward_id"
  end

  add_index "users", ["facebook_id"], :name => "index_users_on_facebook_id"
  add_index "users", ["facebook_session_key"], :name => "index_users_on_facebook_session_key"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["username"], :name => "index_users_on_username"

end
