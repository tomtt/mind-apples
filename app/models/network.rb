# == Schema Information
#
# Table name: networks
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  url         :string(255)
#  form_header :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Network < ActiveRecord::Base
  has_many :people

  def to_param
    url
  end
end
