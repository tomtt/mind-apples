# == Schema Information
#
# Table name: people
#
#  id                        :integer(4)      not null, primary key
#  name                      :string(255)
#  email                     :text
#  page_code                 :string(255)
#  braindump                 :text
#  location                  :string(255)
#  gender                    :string(255)
#  age                       :string(255)
#  occupation                :string(255)
#  health_check              :string(255)
#  tags                      :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  login                     :string(255)     default(""), not null
#  crypted_password          :string(255)     default(""), not null
#  password_salt             :string(255)     default(""), not null
#  persistence_token         :string(255)     default(""), not null
#  single_access_token       :string(255)     default(""), not null
#  perishable_token          :string(255)     default(""), not null
#  login_count               :integer(4)      default(0), not null
#  failed_login_count        :integer(4)      default(0), not null
#  last_request_at           :datetime
#  current_login_at          :datetime
#  last_login_at             :datetime
#  current_login_ip          :string(255)
#  last_login_ip             :string(255)
#  has_received_welcome_mail :boolean(1)
#  public_profile            :boolean(1)      default(TRUE)
#  policy_checked            :boolean(1)
#  password_saved            :boolean(1)      default(FALSE)
#

class Person < ActiveRecord::Base
  AUTOGEN_LOGIN_PREFIX = 'autogen_'
  DEFAULT_IMAGE_URL = "/images/icons/missing_:style.png"
  validates_presence_of :policy_checked, :unless => Proc.new { |person| person.policy_checked.nil? }, :message => :"policy_checked.blank"
  validates_presence_of :page_code

  validates_presence_of :email, :if => Proc.new { |person| person.login_set_by_user?}, :message => :"email.blank"
  validates_uniqueness_of :email, :allow_nil => true, :allow_blank => true, :message => :"email.unique"

  validates_format_of :login, :with => /^[^_]/, :message => :"login.format"
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :if => Proc.new { |person| person.login_set_by_user? && !person.email.blank? }, :message => :"email.format"
  validate :login_can_not_start_with_autogen_string_unless_page_code_matches

  before_save :maybe_send_welcome_email
  before_save :ensure_name_is_not_blank

  acts_as_authentic do |config|
    config.merge_validates_length_of_password_field_options :message => :"password.length"
    config.merge_validates_confirmation_of_password_field_options :message => :"password_confirmation.dont_match"
    config.merge_validates_uniqueness_of_login_field_options :message => :"login.taken"
    config.validate_email_field false
  end

  has_many :mindapples, :dependent => :nullify
  has_and_belongs_to_many :liked_mindapples, :class_name => "Mindapple"

  # paperclip
  has_attached_file :avatar, :styles => { :medium => "150x150>", :thumb => "40x40>" }, :default_url => DEFAULT_IMAGE_URL

  #attach file validation from paper clip is not used here, because we can't use :"avatar.size" for specification of error message format.
  validates_inclusion_of :"avatar_file_size", :in => 0..512000, :unless => Proc.new { |person| person.avatar.original_filename.nil? }, :message => :"avatar.size"

  accepts_nested_attributes_for :mindapples

  attr_protected :login, :page_code

  def self.new_with_mindapples(attributes = {})
    new(attributes).ensure_correct_number_of_mindapples
  end

  def ensure_correct_number_of_mindapples
    chop_superfluous_mindapples
    (5 - mindapples.size).times { mindapples.build }
    self
  end

  def protected_login=(value)
    unless login_set_by_user?
      self.login = value
    end
  end
  
  def login_set_by_user?
    login &&
      !login.blank? &&
      login != '%s%s' % [AUTOGEN_LOGIN_PREFIX, page_code] &&
      !errors["login"]
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    PersonMailer.deliver_set_password(self)
  end

  def to_s
    to_param
  end

  def name_for_view
    if name
      name
    else
      if login_set_by_user?
        login
      end
    end
  end

  def self.find_by_param(param)
    if param.index('_') == 0
      find_by_page_code(param[1..-1])
    else
      find_by_login(param)
    end
  end

  def to_param
    if login.index(AUTOGEN_LOGIN_PREFIX)
      '_' + page_code
    else
      login
    end
  end

  def unique_email?
    person = Person.find_by_email(self.email)
    person.nil? || person.id == self.id
  end

  private

  def chop_superfluous_mindapples
    return unless mindapples.size > 5
    number_to_chop = mindapples.size - 5
    number_to_chop.times { chop_one_mindapple }
  end

  def chop_one_mindapple
    mindapples.delete(mindapples.first)
  end

  def maybe_send_welcome_email
    if !email.blank? && !has_received_welcome_mail
      PersonMailer.deliver_welcome_email(self)
      self.has_received_welcome_mail = true
    end
  end

  def login_can_not_start_with_autogen_string_unless_page_code_matches
    if login.index(AUTOGEN_LOGIN_PREFIX) == 0 && login != '%s%s' % [AUTOGEN_LOGIN_PREFIX, page_code]
      if login_changed?
        self.login = login_was
      end
      errors.add('login', "can not start with '#{AUTOGEN_LOGIN_PREFIX}'")
    end
  end

  def ensure_name_is_not_blank
    if name.blank?
      self.name = nil
    else
      self.name.strip!
    end
  end
  
end
