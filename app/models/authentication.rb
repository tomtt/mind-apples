class Authentication < ActiveRecord::Base
  belongs_to :user

  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end

  def self.create_from_hash(hash, person, user = nil)
    user ||= User.create_from_hash(hash)
    person = Person.update_from_user_and_hash(user, hash, person)
    Authentication.create(:user_id => user.id, :uid => hash['uid'], :provider => hash['provider'])
  end
end
