class NetworksController < ApplicationController
  before_filter :redirect_unless_user_is_admin, :except => [:show]

  def show
    if params[:network]
      @network = Network.find_by_url(params[:network]) or render_404
    end
    @most_liked = Mindapple.most_liked_within_network(@network, PagesController::TOP_APPLES_MAX)
    @most_recent = Mindapple.most_recent(PagesController::TOP_APPLES_MAX) # TODO: Needs to be limited to network
    unless current_user
      @user_session = UserSession.new
    end
  end

  def admin
    @network = Network.find_by_url(params[:network])
  end

  def redirect_unless_user_is_admin
    admin_users = %w{tomtt andy}
    redirect_to(root_path) unless current_user && admin_users.include?(current_user.login)
  end
end
