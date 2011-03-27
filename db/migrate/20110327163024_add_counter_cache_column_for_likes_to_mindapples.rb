class AddCounterCacheColumnForLikesToMindapples < ActiveRecord::Migration
  def self.up
    add_column :mindapples, :mindapple_likings_count, :integer
  end

  def self.down
    remove_column :mindapples, :mindapple_likings_count
  end
end
