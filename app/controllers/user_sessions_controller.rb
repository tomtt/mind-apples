class UserSessionsController < ApplicationController
  resources_controller_for :user_session, :singleton => true, :load_enclosing => false

  # before_filter :require_no_user, :only => [:new, :create]
  before_filter :logout_if_current_user, :only => [:create]
  before_filter :require_user, :only => :destroy

  response_for :create do |format|
    
    format.html do
      if @resource_saved
        flash[:notice] = "Login successful!"
        if network = Network.find_by_id(params["network_id"])
          redirect_back_or_default network_path(network)
        else
          redirect_back_or_default person_path(resource.person)
        end
      else
        if params[:network_id]
          @network = Network.find_by_id(params[:network_id])
        end
        render :action => :new
      end
    end
  end

  def twitter_login
    # @callback_url = "http://127.0.0.1:3000/twitter_callback"
    @callback_url = "http://mindapples.heroku.com/twitter_callback"
    
    consumer = UserSession.oauth_consumer
    request_token = consumer.get_request_token(:oauth_callback => @callback_url)
    # request_token = consumer.get_request_token
    
    session[:request_token] = request_token
    redirect_to request_token.authorize_url
  end
  
  def twitter_callback
    debugger
    access_token = session[:request_token].get_access_token(:oauth_verifier => params[:oauth_verifier])
    Person.create(:oauth_token => access_token.token, :oauth_secret => access_token.secret)
  end
  
  def destroy
    @last_logged_in_user_id = current_user.to_param
    current_user_session.destroy
  end

  response_for :destroy do |format|
    format.html do
      flash[:notice] = "Logout successful!"
      redirect_back_or_default person_path(@last_logged_in_user_id)
    end
  end

  protected

  def logout_if_current_user
    current_user_session && current_user_session.destroy
  end
end
