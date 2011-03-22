class PapercliperizeNetworkLogo < ActiveRecord::Migration
  def self.up
    remove_column :networks, :logo_url
    add_column :networks, :logo_file_name,    :string
    add_column :networks, :logo_content_type, :string
    add_column :networks, :logo_file_size,    :integer
    add_column :networks, :logo_updated_at,   :datetime
  end

  def self.down
    add_column :networks, :logo_url, :string
    remove_column :networks, :logo_file_name
    remove_column :networks, :logo_content_type
    remove_column :networks, :logo_file_size
    remove_column :networks, :logo_updated_at
  end
end
