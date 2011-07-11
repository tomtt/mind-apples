class AddOathFieldsToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :oauth_token, :string
    add_column :people, :oauth_secret, :string
    add_index :people, :oauth_token

    change_column :people, :login, :string, :default => nil, :null => true
    change_column :people, :crypted_password, :string, :default => nil, :null => true
    change_column :people, :password_salt, :string, :default => nil, :null => true
  end

  def self.down
    remove_column :people, :oauth_token
    remove_column :people, :oauth_secret

    [:login, :crypted_password, :password_salt].each do |field|
      Person.all(:conditions => "#{field} is NULL").each { |person| person.update_attribute(field, "") if person.send(field).nil? }
      change_column :people, field, :string, :default => "", :null => false
    end
  end
end
