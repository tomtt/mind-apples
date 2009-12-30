class Person < ActiveRecord::Base
  AUTOGEN_LOGIN_PREFIX = 'autogen_'

  validates_presence_of :page_code
  validates_format_of :login, :with => /^[^_]/, :message => 'can not begin with an underscore'
  validate :login_can_not_be_changed_to_a_value_starting_with_autogen_string

  before_save :maybe_send_welcome_email

  acts_as_authentic do |config|
    config.validate_email_field false
  end
  has_many :mindapples, :dependent => :nullify

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
    login && !login.empty? && login != '%s%s' % [AUTOGEN_LOGIN_PREFIX, page_code]
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    PersonMailer.deliver_set_password(self)
  end

  def to_s
    to_param
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

  def login_can_not_be_changed_to_a_value_starting_with_autogen_string
    if login_changed? && !login_was.blank? && login.index(AUTOGEN_LOGIN_PREFIX) == 0
      self.login = login_was
      errors.add('login', "can not start with '#{AUTOGEN_LOGIN_PREFIX}'")
    end
  end
end
