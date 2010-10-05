class CreateNetworks < ActiveRecord::Migration
  def self.up
    create_table :networks do |t|
      t.string :name
      t.string :url
      t.text :form_header

      t.timestamps
    end
  end

  def self.down
    drop_table :networks
  end
end
