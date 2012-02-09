class AuthenticationsController < ApplicationController
  def create
#   render :text => request.env["omniauth.auth"].to_yaml
    auth = request.env["omniauth.auth"]
    @uathentication = Authentication.find_from_hash(auth)
    if current_user
      flash[:notice] = "Successfully added #{auth['provider']} authentication"
      current_user.authentications.create(:provider => auth['provider'], :uid => auth['uid'])
      redirect_to person_path(current_user.person)
    elsif @authentication
      flash[:notice] = "Welcome back"
      UserSession.create(@authentication.user, true)
      redirect_to root_url
    else
      person = Person.find_by_page_code(cookies[:page_code].to_s)
      @new_auth = Authentication.create_from_hash(auth, current_user, person)
      flash[:notice] = "Welcome, your account has been created."
      UserSession.create(@new_auth.user, true)
      cookies.delete :page_code
      redirect_to person_path(person)
    end
  end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication"
    redirect_to person_path(current_user.person)
  end

  def failure
    flash[:notice] =  "Sorry, you didn't Authorize"
    redirect_to root_url
  end

  def blank
    render :text => "Not Found", :status => 404
  end
end
