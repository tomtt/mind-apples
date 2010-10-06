class NetworksController < ApplicationController
  before_filter :redirect_unless_user_is_admin

  def admin
    @network = Network.find_by_url(params[:network])
  end

  def redirect_unless_user_is_admin
    admin_users = %w{tomtt andy}
    redirect_to(root_path) unless current_user && admin_users.include?(current_user.login)
  end
end
