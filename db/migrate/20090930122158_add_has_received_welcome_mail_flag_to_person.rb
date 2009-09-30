class AddHasReceivedWelcomeMailFlagToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :has_received_welcome_mail, :boolean
  end

  def self.down
    remove_column :people, :has_received_welcome_mail
  end
end
