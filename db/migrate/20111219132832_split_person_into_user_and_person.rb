class SplitPersonIntoUserAndPerson < ActiveRecord::Migration
  
  @fields = [:email, :login, :crypted_password, :password_salt, :persistence_token, :single_access_token, :perishable_token, :login_count, :failed_login_count, :last_request_at, :current_login_at, :last_login_at, :current_login_ip, :last_login_ip]
  
  class MyPerson < ActiveRecord::Base
    set_table_name 'people'
    
    def anonymous?
      login =~ /\A#{Person::AUTOGEN_LOGIN_PREFIX}/
    end
    
  end
  
  class MyUser < ActiveRecord::Base
    set_table_name 'users'
  end
  
  def self.create_users_table
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
  end
  
  def self.move_people_data_to_users
    MyPerson.find_each do |person|
      # Do not migrate people if they have been auto-generated
      next if person.anonymous?
      
      parameters = {}
      @fields.each { |field| parameters[field] = person.send(field) }
      MyUser.create!(parameters)

      # PENDING: set up association between Person and User.
    end
  end
  
  def self.delete_redundant_columns_from_people
    # TBC, we are going to have to keep email and login, though.
  end
  
  def self.up
    create_users_table
    move_people_data_to_users
    delete_redundant_columns_from_people
  end

  def self.down
    remove_index :users, :column => :email
    remove_index :users, :column => :login
    drop_table :users
  end
end