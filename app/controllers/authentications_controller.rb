class AuthenticationsController < ApplicationController
  def create

    auth = request.env["omniauth.auth"]
    @authentication = Authentication.find_from_hash(auth)
    if current_user
      notice = "Successfully added #{auth['provider']} authentication"
      current_user.authentications.create(:provider => auth['provider'], :uid => auth['uid'])
      user = current_user
    elsif @authentication
      notice = "Welcome back"
      user = @authentication.user
      UserSession.create(user, true)
    else
      user = User.find_by_login(auth['user_info']['name'].scan(/[a-zA-Z0-9_]/).to_s.downcase)
      if user.blank?
        person = Person.find_by_page_code(cookies[:page_code].to_s)
        @new_auth = Authentication.create_from_hash(auth, person)
        notice = "Welcome, your account has been created."
        user = @new_auth.user
        UserSession.create(user, true)
        cookies.delete :page_code
      else
        path = root_url
        notice = "A user with the same login already exists"
      end
    end
    
    flash[:notice] = notice
    redirect_to path || person_path(user.person)
  end

  def failure
    flash[:notice] =  "Sorry, you didn't Authorize"
    redirect_to root_url
  end
end
