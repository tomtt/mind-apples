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
  acts_as_authentic do |config|
    # login
    config.merge_validates_format_of_login_field_options :with => /\A[a-z0-9_-]+\z/i, :message => :"login.format"
    # email
    config.merge_validates_length_of_email_field_options :if => Proc.new { |user| user.email.present? }
    config.merge_validates_format_of_email_field_options :if => Proc.new { |user| user.email.present? }
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

  attr_protected :role

  def is_admin?
    role == "admin"
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    PersonMailer.deliver_set_password(self)
  end
end
