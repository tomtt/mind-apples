class PagesController < ApplicationController
  layout :choose_layout
  
  TOP_APPLES_MAX = 5
  MOST_RECENT_APPLES_MAX = 5
  
  def home
    @person = Person.new_with_mindapples
    @blogfeeds = BlogFeed.latest(3)
    @most_liked = Mindapple.most_liked(TOP_APPLES_MAX)
    @most_recent = Mindapple.most_recent(TOP_APPLES_MAX)
  end

  def error
    raise 'Intentional error'
  end

  def homepage
    session[:suggestions] = params[:person][:mindapples_attributes] if params[:person] && params[:person][:mindapples_attributes]
    redirect_to new_person_path
  end

  private

  def choose_layout
    case action_name
    when "about", "about_team", "how_we_got_here"
      "about"
    when "grow", "donate", "volunteer", "grow_your_own"
      "grow"
    when "services", "individuals", "workplaces", "schools", "universities", "communities", "healthcare"
      "services"
    else
      "application"
    end
  end
end
