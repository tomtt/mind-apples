# == Schema Information
#
# Table name: networks
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  url               :string(255)
#  description       :text
#  created_at        :datetime
#  updated_at        :datetime
#  logo_file_name    :string(255)
#  logo_content_type :string(255)
#  logo_file_size    :integer
#  logo_updated_at   :datetime
#

class Network < ActiveRecord::Base
  has_many :people
  
  has_attached_file :logo,
                    :styles => { :medium => '#162x162' }
  

  def to_param
    url
  end
end
