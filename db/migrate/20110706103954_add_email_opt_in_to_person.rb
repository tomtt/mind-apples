class AddEmailOptInToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :email_opt_in, :boolean
  end

  def self.down
    remove_column :people, :email_opt_in
  end
end
