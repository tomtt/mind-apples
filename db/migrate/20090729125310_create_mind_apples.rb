class CreateMindApples < ActiveRecord::Migration
  def self.up
    create_table :mind_apples do |t|
      t.text :suggestion
      t.references :respondent

      t.timestamps
    end
  end

  def self.down
    drop_table :mind_apples
  end
end
