class AddReferralCodeToSurvey < ActiveRecord::Migration
  def self.up
    add_column :surveys, :referral_code, :string
  end

  def self.down
    remove_column :surveys, :referral_code
  end
end
