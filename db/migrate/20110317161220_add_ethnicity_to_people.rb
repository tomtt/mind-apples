class AddEthnicityToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :ethnicity, :string
  end

  def self.down
    remove_column :people, :ethnicity
  end
end
