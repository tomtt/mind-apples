class UserSessionsController < ApplicationController
  resources_controller_for :user_session, :except => :create, :singleton => true, :load_enclosing => false

  # before_filter :require_no_user, :only => [:new, :create]
  before_filter :logout_if_current_user, :only => [:create]
  before_filter :require_user, :only => :destroy
  skip_before_filter :http_auth_when_on_staging, :only => [:create]

  # def create_from_oauth
  #   @user_session = UserSession.new(params[:user_session])
  #   # uses a block to prevent double render error...
  #   # because oauth and openid use redirects
  #   @user_session.save do |result|
  #     if result
  #       flash[:notice] = "Login successful!"
  #       redirect_to current_user ? profile_url(current_user) : login_url
  #     else
  #       if @user_session.errors.on(:user)
  #         # if we set error on the base object, likely it's because we didn't find a user
  #         render :action => :confirm
  #       else
  #         render :action => :new
  #       end
  #     end
  #   end
  # end

  def create
    @user_session = UserSession.new(params[:user_session])
    @resource_saved = @user_session.save
    
    respond_to do |format|
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
