# == Schema Information
#
# Table name: authorizations
#
#  id         :integer         not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  person_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Authorization < ActiveRecord::Base
  VALID_PROVIDERS = ["twitter"]
  
  belongs_to :person
  
  validates_presence_of :uid, :person_id
  validates_inclusion_of :provider, :in => VALID_PROVIDERS
  validates_uniqueness_of :provider, :scope => [:uid, :person_id]
end
