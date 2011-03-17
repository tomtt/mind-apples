class AddImportFieldsToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :import_s3_etag, :string
    add_column :people, :type_description, :string
  end

  def self.down
    remove_column :people, :type_description
    remove_column :people, :import_s3_etag
  end
end
