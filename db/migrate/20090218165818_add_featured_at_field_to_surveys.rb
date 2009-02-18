class AddFeaturedAtFieldToSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :featured_at, :datetime
  end

  def self.down
    remove_column :surveys, :featured_at
  end
end
