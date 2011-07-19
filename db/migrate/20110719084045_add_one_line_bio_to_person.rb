class AddOneLineBioToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :one_line_bio, :string
  end

  def self.down
    remove_column :people, :one_line_bio
  end
end
