class AddPublicProfileToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :public_profile, :boolean, :default => true
  end

  def self.down
    remove_column :people, :public_profile
  end
end
