#######
#
# This file will be run on every deploy, so make sure the changes here are non-destructive
#
#######

module DefaultAdminSeeds
  def self.seed_all
    admin_emails = ["mindapples@tomtenthij.nl", "andy@sociability.org.uk"]
    admin_emails.each do |email|
      user = Person.find_by_email!(email)
      user.role = "admin"
      user.save!
    end
  end
end

DefaultAdminSeeds.seed_all
