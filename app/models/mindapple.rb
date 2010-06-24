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
    Mindapple.find(:all, :select => "mindapple_id as id, suggestion, ma.created_at as created_at, people.name as author, count(*) as total",
                         :joins => "as map inner join mindapples as ma on map.mindapple_id = ma.id inner join people on people.id = map.person_id",
                         :from => "mindapples_people",
                         :group => "mindapple_id",
                         :order => "total DESC",
                         :limit => max)
  end
  
  def self.most_recent(max)
    Mindapple.find(:all, :group => "person_id",
                         :order => "created_at DESC",
                         :limit => max)
  end
  
end
