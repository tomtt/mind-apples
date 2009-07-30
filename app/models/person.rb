class Person < ActiveRecord::Base
  has_many :mindapples, :dependent => :nullify

  accepts_nested_attributes_for :mindapples

  def ensure_corrent_number_of_mindapples
    5.times { mindapples.build }
  end
end
