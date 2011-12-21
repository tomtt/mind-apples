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
          if current_user.person
            redirect_back_or_default person_path(current_user.person)
          else
            redirect_back_or_default root_path
          end
        end
      else
        if params[:network_id]
          @network = Network.find_by_id(params[:network_id])
        end
        render :action => :new
      end
    end
  end

  def destroy
    @last_logged_in_person_param = current_user.person.try(:to_param)
    current_user_session.destroy
  end

  response_for :destroy do |format|
    format.html do
      flash[:notice] = "Logout successful!"
      if network = Network.find_by_id(params["network_id"])
        redirect_back_or_default network_path(network)
      else
        if @last_logged_in_person_param
          redirect_back_or_default person_path(@last_logged_in_person_param)
        else
          redirect_back_or_default root_path
        end
      end
    end
  end

  protected

  def logout_if_current_user
    current_user_session && current_user_session.destroy
  end
end
