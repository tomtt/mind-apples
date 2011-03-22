class RenameFormHeaderToIntroductionOnNetworks < ActiveRecord::Migration
  def self.up
    rename_column :networks, :form_header, :description
  end

  def self.down
    rename_column :networks, :description, :form_header
  end
end
