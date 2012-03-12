class AuthenticationsController < ApplicationController
  def create
    #raise request.env["omniauth.auth"].to_yaml
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
      user = User.find_by_login(User.nickname_or_uid_from_hash(auth))
      page_code = Authlogic::Random.friendly_token
      if user.blank?
        if cookies[:page_code].nil?
          person = Person.create_dummy_person(page_code)
        else
          person = Person.find_by_page_code(cookies[:page_code].to_s)
        end
        @new_auth = Authentication.create_from_hash(auth, person)
        notice = "Thanks for sharing your mindapples! You're all signed up and ready to go."
        user = @new_auth.user
        UserSession.create(user, true)
        cookies.delete :page_code
      else
        person = Person.create_dummy_person(page_code)
        path = register_person_path(person)
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
