class AssociatePersonWithNetwork < ActiveRecord::Migration
  def self.up
    add_column :people, :network_id, :integer
  end

  def self.down
    remove_column :people, :network_id
  end
end
