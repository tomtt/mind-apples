class AddSurveyMonkeyFieldsToSurveys < ActiveRecord::Migration
  def self.up
    add_column :surveys, :respondent_id, :integer
    add_column :surveys, :start_date, :datetime
    add_column :surveys, :end_date, :datetime
  end

  def self.down
    remove_column :surveys, :respondent_id
    remove_column :surveys, :start_date
    remove_column :surveys, :end_date
  end
end
