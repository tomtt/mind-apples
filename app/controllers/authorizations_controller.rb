class AuthorizationsController < ApplicationController
  def create
    omniauth = request.env['omniauth.auth']
    auth = Authorization.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    
    if current_user
      if current_user.authorizations.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
        flash[:notice] = "Successfully added #{omniauth['provider']} authentication."
      else
        flash[:notice] = "You have already authorized your #{omniauth['provider']} account."
      end
    elsif auth
      flash[:notice] = "Welcome back #{omniauth['provider']} user."
      UserSession.create(auth.person, true) # User is present. Login the user with his social account
    else
      new_person = Person.create()
      @new_auth = Authorization.create(:) #Create a new user
      flash[:notice] = "Welcome #{omniauth['provider']} user. Your account has been created."
      UserSession.create(@new_auth.user, true) #Log the authorizing user in.
    end
    redirect_to current_user
  end
  
  def failure
    flash[:notice] = "Sorry, You din't authorize"
    redirect_to root_url
  end
  
  def destroy
    @authorization = current_user.authorizations.find(params[:id])
    flash[:notice] = "Successfully deleted #{@authorization.provider} authentication."
    @authorization.destroy
    redirect_to root_url
  end
end
