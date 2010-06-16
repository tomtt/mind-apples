class AddPasswordSavedToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :password_saved, :boolean, :default => false
  end

  def self.down
    remove_column :people, :password_saved
  end
end
