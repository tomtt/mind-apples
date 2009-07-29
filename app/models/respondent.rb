class Respondent < ActiveRecord::Base
  has_many :mind_apples, :dependent => :nullify

  accepts_nested_attributes_for :mind_apples

  def initialize_mindapples
    5.times { mind_apples.build }
  end
end
