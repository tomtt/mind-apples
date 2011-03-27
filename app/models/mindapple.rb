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
  has_many :mindapple_likings
  has_many :fans, :through => :mindapple_likings

  def self.most_liked(max)
    most_liked_within_context(Mindapple, max)
  end

  def self.most_liked_within_network(network, max)
    most_liked_within_context(network.mindapples, max)
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
  
  private

  def self.most_liked_within_context(context, max)
    context.find(:all, :order => "mindapple_likings_count DESC", :limit => max, :conditions => "mindapple_likings_count > 0")
  end
end
