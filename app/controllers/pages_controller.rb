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

  def debug
    if ENV["DEBUG_ENABLED"] && ENV["DEBUG_ENABLED"].downcase == "true"
      @env = {}
      ENV.keys.each do |key|
        @env[key] =
          if %w{CONSOLE_AUTH DATABASE_URL SHARED_DATABASE_URL S3_SECRET S3_KEY}.include?(key)
            ENV[key][0..4] + "[secret]"
          else
            ENV[key]
          end
      end

      @bucket = Paperclip::Attachment.default_options[:bucket]
    else
      redirect_to root_path
    end
  end

  def homepage
    session[:suggestions] = params[:person][:mindapples_attributes] if params[:person] && params[:person][:mindapples_attributes]
    redirect_to new_person_path
  end
  
  def share_on_social_media
    render :layout => false
  end

  private

  def choose_layout
    case action_name
    when "about", "team", "how_we_got_here", "organisation", "evidence", "contact", "media", "jobs", "terms", "privacy", "research", "survey", "satisfaction", "feedback"
      "about"
    when "grow", "join_us", "partnerships", "volunteer", "donate", "grow_your_own", "shop", "events", "bigtreat", "feedyourhead", "mindcider"
      "grow"
    when "services", "engagement", "insights", "training", "programmes", "testimonials", "yourmind", "tree"
      "services"
    else
      "application"
    end
  end
end
