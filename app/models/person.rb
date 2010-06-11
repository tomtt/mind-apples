class Person < ActiveRecord::Base
  AUTOGEN_LOGIN_PREFIX = 'autogen_'

  validates_presence_of :page_code
  validates_presence_of :policy_checked, :on => :create
  validates_presence_of :email, :if => Proc.new { |person| person.login_set_by_user? }
  validates_uniqueness_of :email, :on => :create, :unless => Proc.new { |person| person.email.nil? }, :message => "email already taken"
  validates_uniqueness_of :email, :on => :update, :if => Proc.new { |person| !person.unique_email? && !person.email.blank? }, :message => "email already taken"
  
  validates_format_of :login, :with => /^[^_]/, :message => 'can not begin with an underscore'
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :if => Proc.new { |person| person.login_set_by_user? && !person.email.blank? }
  validate :login_can_not_start_with_autogen_string_unless_page_code_matches

  before_save :maybe_send_welcome_email
  before_save :ensure_name_is_not_blank

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