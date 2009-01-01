class CreateSurveys < ActiveRecord::Migration
  def self.up
    create_table :surveys do |t|
      t.text :apple_1
      t.text :apple_2
      t.text :apple_3
      t.text :apple_4
      t.text :apple_5
      t.integer :health_check
      t.text :suggested_people
      t.string :age_range
      t.string :country
      t.string :name
      t.string :email

      t.timestamps
    end
  end

  def self.down
    drop_table :surveys
  end
end
