class Person < ActiveRecord::Base
  acts_as_authentic do |config|
    config.validate_email_field false
  end
  has_many :mindapples, :dependent => :nullify

  accepts_nested_attributes_for :mindapples

  def ensure_corrent_number_of_mindapples
    chop_superfluous_mindapples
    (5 - mindapples.size).times { mindapples.build }
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
