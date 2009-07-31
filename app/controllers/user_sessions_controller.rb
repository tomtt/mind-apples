class UserSessionsController < ApplicationController
  resources_controller_for :user_sessions
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  response_for :create do |format|
    format.html do
      if @resource_saved
        flash[:notice] = "Login successful!"
        redirect_back_or_default account_url
      else
        render :action => :new
      end
    end
  end

  response_for :destroy do |format|
    format.html do
      flash[:notice] = "Logout successful!"
      redirect_back_or_default new_user_session_url
    end
  end
end
