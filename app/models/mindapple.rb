# == Schema Information
#
# Table name: mindapples
#
#  id         :integer(4)      not null, primary key
#  suggestion :text
#  person_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Mindapple < ActiveRecord::Base
  belongs_to :person
  has_and_belongs_to_many :fans, :class_name => "Person"
  
  def self.most_liked(max)
    Mindapple.find(:all, :select => "mindapple.id, count(*) as total", :from => "mindapples_people", :group => "mindapple_id", :order => "total", :limit => max)
  end
end
