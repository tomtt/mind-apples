class AddPolicyCheckedToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :policy_checked, :boolean
  end

  def self.down
    remove_column :people, :policy_checked
  end
end
