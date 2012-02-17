class AddExternalAvatarUrlToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :external_avatar_url, :string
  end

  def self.down
    remove_column :people, :external_avatar_url
  end
end
