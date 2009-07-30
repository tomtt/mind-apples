class RenameMindApplesModelToMindapples < ActiveRecord::Migration
  def self.up
    rename_table :mind_apples, :mindapples
  end

  def self.down
    rename_table :mindapples, :mind_apples
  end
end
