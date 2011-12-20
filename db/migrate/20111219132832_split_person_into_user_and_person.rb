class SplitPersonIntoUserAndPerson < ActiveRecord::Migration
  
  class MyPerson < ActiveRecord::Base
    set_table_name 'people'
  end
  
  class MyUser < ActiveRecord::Base
    set_table_name 'users'
  end
  
  def self.up
    create_table :users do |t|
      t.string   "email",                     :null => false
      t.string   "login",                     :null => false
      t.string   "crypted_password",          :null => false
      t.string   "password_salt",             :null => false
      t.string   "persistence_token",         :null => false
      t.string   "single_access_token",       :null => false
      t.string   "perishable_token",          :null => false
      t.integer  "login_count",               :default => 0,     :null => false
      t.integer  "failed_login_count",        :default => 0,     :null => false
      t.datetime "last_request_at"
      t.datetime "current_login_at"
      t.datetime "last_login_at"
      t.string   "current_login_ip"
      t.string   "last_login_ip"

      t.timestamps
    end
    add_index :users, :login, :unique => true
    add_index :users, :email, :unique => true
    
    fields = [:email, :login, :crypted_password, :password_salt, :persistence_token, :single_access_token, :perishable_token, :login_count, :failed_login_count, :last_request_at, :current_login_at, :last_login_at, :current_login_ip, :last_login_ip]
    
    MyPerson.find_each do |person|
      # Do not migrate people if they have been auto-generated
      next if person.login =~ /\A#{Person::AUTOGEN_LOGIN_PREFIX}/
      
      parameters = {}
      fields.each { |field| parameters[field] = person.send(field) }
      MyUser.create!(parameters)
    end
    
  end

  def self.down
    remove_index :users, :column => :email
    remove_index :users, :column => :login
    drop_table :users
  end
end