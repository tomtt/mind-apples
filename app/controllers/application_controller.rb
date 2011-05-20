# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  MIGRATING_TO_HEROKU = false

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

  before_filter :redirect_if_migrating_to_heroku
  before_filter :http_auth_when_on_staging

  # rescue_from Exception, :with => :render_500
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  protected
  def render_404
    render :template => "errors/error_404", :status => "404 Not Found"
  end

  def render_500
    render :template => "errors/error_500", :status => "500"
  end

  private

  def http_auth_when_on_staging
    if request.host =~ /staging/
      authenticate_or_request_with_http_basic do |username, password|
        MD5.new(username) == "de7e2387e909e44c6464cf801203b3c7" && MD5.new(password) == "19b5e81413e74a9105712cc970cd98e3"
      end
    end
  end

  def redirect_if_migrating_to_heroku
    if MIGRATING_TO_HEROKU &&
        ! %w{show index}.include?(params[:action]) &&
        ! %w{pages}.include?(params[:controller]) &&
        ! (request.path == "/logout")
      location = %w{home pasture field location residence accomodation property address hearth nest habitation}.rand
      flash[:notice] = "Mindapples is moving to a better #{location}. Some bits of the site have been disabled, please try again later."
      redirect_to root_path
    end
  end

  def current_user_session
    #this solve the error: You must activate the Authlogic::Session::Base.controller
    Authlogic::Session::Base.controller = Authlogic::ControllerAdapters::RailsAdapter.new(self)
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.person
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to root_path
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
