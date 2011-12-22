class RemoveNullSettingFromPersonLogin < ActiveRecord::Migration
  # This is in order to fix the database schema after the login validation
  # has been removed from Person in 6802e253b27335ade370e0085521f1e6ee64dafe
  def self.up
    change_column :people, :login, :string, :null => true
  end

  def self.down
    change_column :people, :login, :string, :null => false
  end
end
