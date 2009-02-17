class AddPrivateAuthFieldToSurvey < ActiveRecord::Migration
  def self.up
    add_column :surveys, :private_auth, :string
  end

  def self.down
    remove_column :surveys, :private_auth
  end
end
