class AddHasAndBelongsToManyRelationshipToPeopleAndMindapples < ActiveRecord::Migration
  def self.up
    create_table :mindapples_people, :id => false do |t|
      t.integer :person_id
      t.integer :mindapple_id

      t.timestamps
    end
    
  end

  def self.down
    drop_table :mindapples_people
  end
end
