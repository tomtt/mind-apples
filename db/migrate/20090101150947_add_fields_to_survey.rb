class AddFieldsToSurvey < ActiveRecord::Migration
  def self.up
    add_column :surveys, :brain_dump, :text
    add_column :surveys, :gender, :string
    rename_column :surveys, :suggested_people, :famous_fives
  end

  def self.down
    rename_column :surveys, :famous_fives, :suggested_people
    remove_column :surveys, :gender
    remove_column :surveys, :brain_dump
  end
end
