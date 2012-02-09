class Authentication < ActiveRecord::Base
  belongs_to :user

  def self.find_from_hash(hash)
    find_by_provider_and_uid(hash['provider'], hash['uid'])
  end

  def self.create_from_hash(hash, user = nil, person = nil)
    user ||= User.create_from_hash(hash)
    person.save(:user_id => user.id, :policy_checked => true, :validate => false )
    Authentication.create(:user_id => user.id, :uid => hash['uid'], :provider => hash['provider'])
  end
end
