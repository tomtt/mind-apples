# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  email               :string(255)     not null
#  login               :string(255)     not null
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer         default(0), not null
#  failed_login_count  :integer         default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class User < ActiveRecord::Base
  acts_as_authentic do |config|
    config.merge_validates_length_of_password_field_options :message => "Please choose a valid password (minimum is 4 characters)"
  end

  # Associations
  has_one :person, :dependent => :nullify

  # Validations
  validates_format_of :login, :with => /\A[a-z0-9_-]+\z/i, :message => 'should only contain alphanumeric characters, dashes or underscores'
  validates_format_of :login, :with => /\A[^_]/, :message => 'should not start with an underscore'
end
