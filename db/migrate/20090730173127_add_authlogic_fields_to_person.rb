class AddAuthlogicFieldsToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :login, :string, :null => false, :default => ''
    add_column :people, :crypted_password, :string, :null => false, :default => ''
    add_column :people, :password_salt, :string, :null => false, :default => ''
    add_column :people, :persistence_token, :string, :null => false, :default => ''
    add_column :people, :single_access_token, :string, :null => false, :default => ''
    add_column :people, :perishable_token, :string, :null => false, :default => ''
    add_column :people, :login_count, :integer, :null => false, :default => 0
    add_column :people, :failed_login_count, :integer, :null => false, :default => 0
    add_column :people, :last_request_at, :datetime
    add_column :people, :current_login_at, :datetime
    add_column :people, :last_login_at, :datetime
    add_column :people, :current_login_ip, :string
    add_column :people, :last_login_ip, :string
  end

  def self.down
    remove_column :people, :last_login_ip
    remove_column :people, :current_login_ip
    remove_column :people, :last_login_at
    remove_column :people, :current_login_at
    remove_column :people, :last_request_at
    remove_column :people, :failed_login_count
    remove_column :people, :login_count
    remove_column :people, :perishable_token
    remove_column :people, :single_access_token
    remove_column :people, :persistence_token
    remove_column :people, :password_salt
    remove_column :people, :crypted_password
    remove_column :people, :login
  end
end
