#######
#
# This file will be run on every deploy, so make sure the changes here are non-destructive
#
#######

module DefaultAdminSeeds
  def self.seed_all
    admin_emails = ["mindapples@tomtenthij.nl", "andy@mindapples.org"]
    admin_emails.each do |email|
      user = Person.find_by_email(email)
      if user
        user.role = "admin"
        if user.changed?
          puts "Gave admin priviledges to user with email '#{email}'"
          user.save!
        end
      else
        puts "Could not find user with email '#{email}'"
      end
    end
  end
end

DefaultAdminSeeds.seed_all
