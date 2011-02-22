class Admin::AdminController < ApplicationController
  layout 'admin'
  before_filter :require_user
  before_filter :require_admin

  private

  def require_admin
    if !current_user.is_admin?
      redirect_to root_url(:protocol => 'http')
      flash[:notice] = "You must be logged in as an admin to access this page"
    end
  end
end
