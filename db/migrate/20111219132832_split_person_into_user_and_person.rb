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
      new_user = MyUser.create!(parameters)
      
      person.update_attributes!(:user_id => new_user.id)
    end
  end
  
  def self.delete_redundant_columns_from_people
    @fields.reject { |field| [:login, :email].include?(field) }.each do |field|
      remove_column :people, field
    end
  end
  
  def self.up
    add_column :people, :user_id, :integer
    add_index :people, :user_id, :unique => true
    create_users_table
    move_people_data_to_users
    delete_redundant_columns_from_people
  end

  def self.down
    remove_index :users, :column => :email
    remove_index :users, :column => :login
    drop_table :users
    remove_index :people, :column => :user_id
    remove_column :people, :user_id
  end
end
