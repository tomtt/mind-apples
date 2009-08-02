class Person < ActiveRecord::Base
  AUTOGEN_LOGIN_PREFIX = 'autogen_'

  validates_presence_of :page_code
  validates_format_of :login, :with => /^[^_]/, :message => 'can not begin with an underscore'

  acts_as_authentic do |config|
    config.validate_email_field false
  end
  has_many :mindapples, :dependent => :nullify

  accepts_nested_attributes_for :mindapples

  def ensure_corrent_number_of_mindapples
    chop_superfluous_mindapples
    (5 - mindapples.size).times { mindapples.build }
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
end
