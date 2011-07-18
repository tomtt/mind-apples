class AddSharedMindapplesToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :shared_mindapples, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :people, :shared_mindapples
  end
end
