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

ActiveRecord::Schema.define(:version => 20111222142308) do

  create_table "blog_feeds", :force => true do |t|
    t.string   "author"
    t.string   "title"
    t.text     "content"
    t.string   "teaser"
    t.date     "published"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mindapple_likings", :force => true do |t|
    t.integer  "mindapple_id"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mindapples", :force => true do |t|
    t.text     "suggestion"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mindapple_likings_count"
  end

  create_table "mindapples_people", :id => false, :force => true do |t|
    t.integer  "person_id"
    t.integer  "mindapple_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "networks", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.text     "email"
    t.string   "page_code",                                    :null => false
    t.text     "braindump"
    t.string   "location"
    t.string   "gender"
    t.string   "age"
    t.string   "occupation"
    t.string   "health_check"
    t.string   "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.boolean  "has_received_welcome_mail"
    t.boolean  "public_profile",            :default => true
    t.boolean  "policy_checked"
    t.boolean  "password_saved",            :default => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "respondent_id"
    t.integer  "network_id"
    t.string   "role"
    t.string   "ethnicity"
    t.string   "import_s3_etag"
    t.string   "type_description"
    t.boolean  "email_opt_in"
    t.boolean  "shared_mindapples",         :default => true,  :null => false
    t.string   "one_line_bio"
    t.integer  "user_id"
  end

  add_index "people", ["page_code"], :name => "index_people_on_page_code", :unique => true
  add_index "people", ["user_id"], :name => "index_people_on_user_id", :unique => true

  create_table "people_imports", :force => true do |t|
    t.text     "s3_etag"
    t.text     "s3_key"
    t.text     "user_type_description"
    t.integer  "network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                              :null => false
    t.string   "login",                              :null => false
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
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
