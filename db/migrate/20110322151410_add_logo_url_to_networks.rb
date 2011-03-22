class AddLogoUrlToNetworks < ActiveRecord::Migration
  def self.up
    add_column :networks, :logo_url, :string
  end

  def self.down
    remove_column :networks, :logo_url
  end
end
