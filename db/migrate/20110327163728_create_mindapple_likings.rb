require "ruby-debug"

class CreateMindappleLikings < ActiveRecord::Migration
  def self.up
    create_table :mindapple_likings do |t|
      t.references :mindapple
      t.references :person

      t.timestamps
    end

    MindappleLiking.find_by_sql("select mindapple_id, person_id, created_at, updated_at from mindapples_people").each { |ml| MindappleLiking.create!(ml.attributes) }
  end

  def self.down
    drop_table :mindapple_likings
  end
end
