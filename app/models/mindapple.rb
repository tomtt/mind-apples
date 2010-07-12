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
    Mindapple.find(:all, :select => "ma.id, ma.suggestion, ma.person_id, ma.created_at, ma.updated_at, count(*) as total",
                         :from => "mindapples",    
                         :joins => "as ma inner join mindapples_people as map on map.mindapple_id = ma.id",
                         :group => "mindapple_id",
                         :order => "total DESC",
                         :limit => max)
  end

  def self.most_recent(max)
    Mindapple.find(:all, :group => "person_id",
                         :order => "created_at DESC",
                         :limit => max)
  end

  named_scope :search_by_suggestion, lambda {|searched_string| {
    :conditions => [ 'suggestion LIKE ?', "%#{searched_string}%"]
  }}

end
