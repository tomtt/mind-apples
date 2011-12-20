class FixupPersonFields < ActiveRecord::Migration
  def self.up
    change_column :people, :page_code, :string, :null => false
    add_index :people, :page_code, :unique => true
  end

  def self.down
    remove_index :people, :column => :page_code
    change_column :people, :page_code, :string, :null => true
  end
end
