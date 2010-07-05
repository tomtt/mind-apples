class AddRespondentIdToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :respondent_id, :integer
  end

  def self.down
    remove_column :people, :respondent_id
  end
end
