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

ActiveRecord::Schema.define(:version => 20090730151856) do

  create_table "mindapples", :force => true do |t|
    t.text     "suggestion"
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people", :force => true do |t|
    t.string   "name"
    t.text     "email"
    t.string   "page_code"
    t.text     "braindump"
    t.string   "location"
    t.string   "gender"
    t.string   "age"
    t.string   "occupation"
    t.string   "health_check"
    t.string   "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
