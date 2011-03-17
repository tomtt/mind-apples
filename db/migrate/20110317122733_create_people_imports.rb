class CreatePeopleImports < ActiveRecord::Migration
  def self.up
    create_table :people_imports do |t|
      t.text :s3_etag
      t.text :s3_key
      t.text :user_type_description
      t.references :network
      t.timestamps
    end
  end

  def self.down
    drop_table :people_imports
  end
end
