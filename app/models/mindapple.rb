# == Schema Information
#
# Table name: mindapples
#
#  id         :integer         not null, primary key
#  suggestion :text
#  person_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Mindapple < ActiveRecord::Base
  belongs_to :person
  has_and_belongs_to_many :fans, :class_name => "Person"

  def self.most_liked(max)
    # Group by does not work in postgres (nor should it). For now using a workaround in order to be able to deploy
    # to Heroku.
    # Details: http://awesomeful.net/posts/72-postgresql-s-group-by

    # Mindapple.find(:all, :select => "ma.id, ma.suggestion, ma.person_id, ma.created_at, ma.updated_at, count(*) as total",
    #                      :from => "mindapples",
    #                      :joins => "as ma inner join mindapples_people as map on map.mindapple_id = ma.id",
    #                      :group => "map.mindapple_id",
    #                      :order => "total DESC",
    #                      :limit => max)

    most_liked_condition =
      "id in (select mindapple_id from mindapples_people group by mindapple_id order by count(*) DESC limit #{max})"

    Mindapple.all(:conditions => most_liked_condition)
  end

  def self.most_recent(max)
    # Group by does not work in postgres (nor should it). For now using a workaround in order to be able to deploy
    # to Heroku.
    # Details: http://awesomeful.net/posts/72-postgresql-s-group-by

    # Mindapple.find(:all, :group => "mindapples.person_id",
    #                      :order => "created_at DESC",
    #                :limit => max)

    Mindapple.find_by_sql("select * from (select distinct on (person_id) mindapples.* from mindapples where not suggestion = '') as temp order by created_at DESC limit #{max};")
  end

  named_scope :search_by_suggestion, lambda {|searched_string| {
    :conditions => [ 'suggestion LIKE ?', "%#{searched_string}%"]
  }}

end
