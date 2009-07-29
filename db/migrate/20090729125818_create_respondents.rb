class CreateRespondents < ActiveRecord::Migration
  def self.up
    create_table :respondents do |t|
      t.string :name
      t.text :email
      t.string :page_code
      t.text :braindump
      t.string :location
      t.string :gender
      t.string :age
      t.string :occupation
      t.string :health_check
      t.string :tags

      t.timestamps
    end
  end

  def self.down
    drop_table :respondents
  end
end
