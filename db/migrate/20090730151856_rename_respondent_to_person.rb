class RenameRespondentToPerson < ActiveRecord::Migration
  def self.up
    rename_table :respondents, :people
    rename_column :mindapples, :respondent_id, :person_id
  end

  def self.down
    rename_column :mindapples, :person_id, :respondent_id
    rename_table :people, :respondents
  end
end
