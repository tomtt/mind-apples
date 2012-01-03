class SplitPersonIntoUserAndPerson < ActiveRecord::Migration
  
  class MyPerson < ActiveRecord::Base
    set_table_name 'people'
  end
  
  class MyUser < ActiveRecord::Base
    set_table_name 'users'
  end
  
  @fields = [:email, :login, :crypted_password, :password_salt, :persistence_token, :single_access_token, :perishable_token, :login_count, :failed_login_count, :last_request_at, :current_login_at, :last_login_at, :current_login_ip, :last_login_ip]

  def self.up
    add_column :people, :user_id, :integer
    add_index :people, :user_id, :unique => true

    # create_users_table
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

    # move_people_data_to_users
    MyPerson.find_each do |person|
      # Do not migrate people if they have been auto-generated
      next if person.login =~ /\Aautogen_/
      
      parameters = {}
      @fields.each { |field| parameters[field] = person.send(field) }
      new_user = MyUser.create!(parameters)
      
      person.update_attributes!(:user_id => new_user.id)
    end

    # delete_redundant_columns_from_people
    @fields.reject { |field| [:email].include?(field) }.each do |field|
      remove_column :people, field
    end
  end

  def self.down
    # re-add columns without null constraints
    add_column :people, "login", :string, :default => "", :null => false
    add_column :people, "crypted_password", :string
    add_column :people, "password_salt", :string
    add_column :people, "persistence_token", :string
    add_column :people, "single_access_token", :string
    add_column :people, "perishable_token", :string
    add_column :people, "login_count",:integer, :default => 0
    add_column :people, "failed_login_count",:integer, :default => 0
    add_column :people, "last_request_at", :datetime
    add_column :people, "current_login_at", :datetime
    add_column :people, "last_login_at", :datetime
    add_column :people, "current_login_ip", :string
    add_column :people, "last_login_ip", :string

    # migrate_data_back
    MyUser.find_each do |user|
      person = MyPerson.find_by_user_id(user.id)
      # Do not migrate if no corresponding person
      next if person.nil?

      parameters = {}
      @fields.each { |field| parameters[field] = user.send(field) }
      person.update_attributes!(parameters)
    end

    # re-add null constraints
    change_column :people, "crypted_password", :string, :null => false
    change_column :people, "password_salt", :string,    :null => false
    change_column :people, "persistence_token", :string, :null => false
    change_column :people, "single_access_token", :string, :null => false
    change_column :people, "perishable_token", :string, :null => false
    change_column :people, "login_count",:integer, :default => 0,     :null => false
    change_column :people, "failed_login_count",:integer, :default => 0,     :null => false

    # remove_users_table
    remove_index :users, :column => :email
    remove_index :users, :column => :login
    drop_table :users

    remove_index :people, :column => :user_id
    remove_column :people, :user_id
  end
end
