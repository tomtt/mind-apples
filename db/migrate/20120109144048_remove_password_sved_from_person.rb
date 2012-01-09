class RemovePasswordSvedFromPerson < ActiveRecord::Migration
  def self.up
    remove_column :people, :password_saved
  end

  def self.down
    add_column :people, :password_saved, :boolean, :default => false
  end
end
