# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  include ExceptionNotifiable

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user

  # # Otherwise there will be lots of exceptions due to people trying standard exploits
  # skip_before_filter :verify_authenticity_token, :only => :render_404
  # skip_after_filter :store_location, :only => [:render_404]
  #
  # def render_404
  #   @page_title = "Sorry, we can't seem to find the page you're looking for."
  #   respond_to do |type|
  #     type.html { render :template => "errors/404", :layout => 'error', :status => 404 }
  #     type.all { render :nothing => true, :status => 404 }
  #   end
  #   true # so we can do "render_404 and return"
  # end
  #
  # protected
  #
  # # http://henrik.nyh.se/2008/07/rails-404
  # def render_optional_error_file(status_code)
  #   debugger
  #   if status_code == :not_found
  #     render_404 and return
  #   else
  #     super
  #   end
  # end
  #
  # def record_not_found
  #   render_404
  # end

  private

  def current_user_session
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
