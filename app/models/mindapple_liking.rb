# == Schema Information
#
# Table name: mindapple_likings
#
#  id           :integer         not null, primary key
#  mindapple_id :integer
#  person_id    :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class MindappleLiking < ActiveRecord::Base
  belongs_to(:liked_mindapple,
             :counter_cache => true,
             :class_name => "Mindapple",
             :foreign_key => :mindapple_id)
  belongs_to :fan, :class_name => "Person", :foreign_key => :person_id
end
