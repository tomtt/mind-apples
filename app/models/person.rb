# == Schema Information
#
# Table name: people
#
#  id                        :integer         not null, primary key
#  name                      :string(255)
#  email                     :text
#  page_code                 :string(255)     not null
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
#  login_count               :integer         default(0), not null
#  failed_login_count        :integer         default(0), not null
#  last_request_at           :datetime
#  current_login_at          :datetime
#  last_login_at             :datetime
#  current_login_ip          :string(255)
#  last_login_ip             :string(255)
#  has_received_welcome_mail :boolean
#  public_profile            :boolean         default(TRUE)
#  policy_checked            :boolean
#  password_saved            :boolean         default(FALSE)
#  avatar_file_name          :string(255)
#  avatar_content_type       :string(255)
#  avatar_file_size          :integer
#  avatar_updated_at         :datetime
#  respondent_id             :integer
#  network_id                :integer
#  role                      :string(255)
#  ethnicity                 :string(255)
#  import_s3_etag            :string(255)
#  type_description          :string(255)
#  email_opt_in              :boolean
#  shared_mindapples         :boolean         default(TRUE), not null
#  one_line_bio              :string(255)
#  user_id                   :integer
#

class Person < ActiveRecord::Base
  AUTOGEN_LOGIN_PREFIX = 'autogen_'
  DEFAULT_IMAGE_URL = "/images/icons/missing_:style.jpg"

  validates_format_of :page_code, :with => /\A[A-Za-z0-9]+\z/
  validates_uniqueness_of :page_code
  before_validation :generate_page_code

  validates_presence_of :policy_checked, :unless => Proc.new { |person| person.policy_checked.nil? }, :message => :"policy_checked.blank"

  validates_uniqueness_of :email, :allow_nil => true, :allow_blank => true, :message => :"email.unique"
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :allow_blank => true, :message => :"email.format"

  validate :login_can_not_start_with_autogen_string_unless_page_code_matches
  # validates_length_of :login, :minimum => 1, :if => Proc.new { |person| debugger;person.login_set_by_user?}, :on => :update, :message => :"email.format"

  before_save :maybe_send_welcome_email
  before_save :ensure_name_is_not_blank

  belongs_to :network

  attr_protected :role

  named_scope :anonymous, { :conditions => ["login LIKE ? " , "#{AUTOGEN_LOGIN_PREFIX}%"] }

  has_many :mindapples, :dependent => :destroy
  has_many :mindapple_likings
  has_many :liked_mindapples, :through => :mindapple_likings

  belongs_to :user
  validates_uniqueness_of :user_id, :allow_nil => true
  accepts_nested_attributes_for :user, :update_only => true, :reject_if => :all_blank

  # paperclip
  has_attached_file :avatar, :styles => { :medium => "150x150", :small => "70x70", :thumb => "40x40" }, :default_url => DEFAULT_IMAGE_URL

  #attach file validation from paper clip is not used here, because we can't use :"avatar.size" for specification of error message format.
  validates_inclusion_of :"avatar_file_size", :in => 0..512000, :unless => Proc.new { |person| person.avatar.original_filename.nil? }, :message => :"avatar.size"

  accepts_nested_attributes_for :mindapples

  attr_protected :login, :page_code

  def self.find_by_param!(param)
    if param =~ /\A_(.*)\z/
      self.find_by_page_code!($1)
    else
      u = User.find_by_login!(param)
      raise ActiveRecord::RecordNotFound if u.person.nil?
      u.person
    end
  end

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

  def deliver_claim_your_page_instructions!
    reset_perishable_token!
    PersonMailer.deliver_claim_your_page(self)
  end
  
  def anonymous?
    self.user_id.nil?
  end

  def is_admin?
    role == "admin"
  end

  def to_s
    to_param
  end

  def name_for_view
    if name.present?
      name
    elsif ! anonymous?
      user.login
    end
  end

  # Deprecated, and will be removed.  Use find_by_param! above.
  def self.find_by_param(param)
    if param.index('_') == 0
      find_by_page_code(param[1..-1])
    else
      find_by_login(param)
    end
  end

  def to_param
    anonymous? ? "_#{self.page_code}" : user.login
  end

  def unique_email?
    person = Person.find_by_email(self.email)
    person.nil? || person.id == self.id
  end

  # This method is used when importing a person from a csv file. The keys are attribute names like
  # 'mindapples_attributes[3][suggestion]', the values are the corresponding values for those
  # attributes. The csv import code expects to get the new user returned if there were no errors, or
  # a string containing an error message if there was an error.
  def self.create_from_keys_and_values(keys, values, attributes = {})
    begin
      attributes.merge!(ModelAttributes.construct(keys, values))
    rescue ArgumentError
      @results << "Parse error: #{e.to_s}"
    end

    begin
      return create_with_random_password_and_login_and_page_code!(attributes)
    rescue => e
      return "#{attributes['email']} (#{attributes['name']}): Error: #{e.to_s}"
    end

  end

  def self.import_avatars_from_live_site
    avatars_to_update = determine_avatars_to_update
    avatars_to_update.each do |person_id, avatar_url|
      Person.find(person_id).update_avatar_from_url(avatar_url)
    end
  end

  def get_attributes_from_live_site
    require "open-uri"

    @@app ||= ActionController::Integration::Session.new
    url = @@app.person_url(self, :format => "xml",  :host => "mindapples.org", :public_override => ENV["public_override"])

    attributes = Hash.from_xml(open(url).read)["person"]
    attributes || {}
  end

  def update_avatar_from_url(avatar_url)
    require "open-uri"
    avatar_url.gsub!(' ', '%20')
    avatar_url.gsub!('[', '%5B')
    avatar_url.gsub!(']', '%5D')
    update_attributes!(:avatar => open(avatar_url))

  rescue OpenURI::HTTPError => e
    person_url = if public_profile
                   ActionController::Integration::Session.new.person_url(self, :host => "mindapples.org")
                 else
                   ActionController::Integration::Session.new.person_url(self, :host => "mindapples.org", :public_override => ENV["public_override"])
                 end
    puts "HTTPError updating the avatar \"#{avatar_url}\" for person with id #{id}: #{person_url}"
  end

  def viewable_by?(user)
    self.public_profile or self.user == user
  end

  def editable_by?(user)
    self.anonymous? or self.user == user
  end

  private

  def generate_page_code
    if self.page_code.blank?
      self.page_code = Authlogic::Random.friendly_token
    end
  end

  def self.determine_avatars_to_update
    avatars_to_update = {}
    json_file_name = Rails.root.join("tmp", "avatars_to_update.json")
    if File.exist?(json_file_name)
      avatars_to_update = JSON.parse(File.read(json_file_name))
    else
      File.open(json_file_name, "w") do |json_file|
        Person.all.each do |person|
          if avatar_url = person.get_attributes_from_live_site["avatar_url"]
            avatars_to_update[person] = avatar_url
          end
        end
        json_file.puts(avatars_to_update.to_json)
      end
    end
    avatars_to_update
  end

  def chop_superfluous_mindapples
    return unless mindapples.size > 5
    number_to_chop = mindapples.size - 5
    number_to_chop.times { chop_one_mindapple }
  end

  def chop_one_mindapple
    mindapples.delete(mindapples.first)
  end

  def maybe_send_welcome_email
    if !email.blank? && !has_received_welcome_mail && !respondent_id
      PersonMailer.deliver_welcome_email(self)
      self.has_received_welcome_mail = true
    end
  end

  def login_can_not_start_with_autogen_string_unless_page_code_matches
    if login && login.index(AUTOGEN_LOGIN_PREFIX) == 0 && login != '%s%s' % [AUTOGEN_LOGIN_PREFIX, page_code]
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
