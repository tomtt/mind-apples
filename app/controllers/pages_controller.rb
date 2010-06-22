class PagesController < ApplicationController
  
  TOP_APPLES_MAX = 5
  MOST_RECENT_APPLES_MAX = 5
  
  def home
    @person = Person.new_with_mindapples
    @blogfeeds = BlogFeed.latest(3)
    @most_liked = Mindapple.find(:all, :select => "mindapple_id, count(*) as total", :from => "mindapples_people", :group => "mindapple_id", :order => "total", :limit => 5)
  end

  def error
    raise 'Intentional error'
  end
end
