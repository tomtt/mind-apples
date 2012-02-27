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
#  role                :string(255)
#

class User < ActiveRecord::Base
  LOGIN_MATCHER = /\A[a-z0-9_-]+\z/i

  acts_as_authentic do |config|
    # login
    config.merge_validates_format_of_login_field_options :with => LOGIN_MATCHER, :message => :"login.format"
    config.merge_validates_uniqueness_of_login_field_options :message => :"login.taken"
    # email
    config.merge_validates_length_of_email_field_options :if => Proc.new { |user| user.email.present? }
    config.merge_validates_format_of_email_field_options :if => Proc.new { |user| user.email.present? }, :message => :"email.format"
    config.merge_validates_uniqueness_of_email_field_options :message => :"email.unique"
    # password
    config.merge_validates_length_of_password_field_options :message => :"password.length"
    config.merge_validates_length_of_password_confirmation_field_options :if => Proc.new { false }
    config.merge_validates_confirmation_of_password_field_options :message => :"password_confirmation.dont_match"
  end
  validates_format_of :login, :with => /\A[^_]/, :message => :"login.underscore"
  validates_presence_of :email, :message => :"email.blank"

  # Associations
  has_one :person, :dependent => :nullify
  has_many :authentications

  attr_protected :role

  def is_admin?
    role == "admin"
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    PersonMailer.deliver_set_password(self)
  end

  def self.nickname_or_uid_from_hash(hash)
    if !hash['user_info']['nickname'].blank?
      username = hash['user_info']['nickname']
      if username.match(LOGIN_MATCHER)
        user = username
      else
        user = username.gsub(".", "")
      end
    else
      user = hash['uid']
    end
    return user
  end

  def self.find_by_login_or_email(login_or_email)
    self.find_by_login(login_or_email) || self.find_by_email(login_or_email)
  end

  def self.create_from_hash(hash)
      random_pass = Authlogic::Random.friendly_token
      single_access = Authlogic::Random.friendly_token
      login = (self.nickname_or_uid_from_hash(hash))
      user = User.new(:login => login,
                      :password => random_pass.to_s,
                      :password_confirmation => random_pass.to_s,
                      :single_access_token => single_access)
      user.save(false)
      user.reset_persistence_token!
      user
  end
end
