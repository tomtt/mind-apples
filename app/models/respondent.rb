class Respondent < ActiveRecord::Base
  has_many :mind_apples, :dependent => :nullify
end
