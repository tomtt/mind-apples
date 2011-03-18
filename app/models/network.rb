class Network < ActiveRecord::Base
  has_many :people

  def to_param
    url
  end
end
