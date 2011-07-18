class AuthorizationsController < ApplicationController
  def create
    omniauth = request.env['omniauth.auth']
    auth = Authorization.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    
    if current_user
      new_auth = current_user.authorizations.new(:provider => omniauth['provider'], :uid => omniauth['uid'])
      if new_auth.save
        flash[:notice] = "Successfully added #{omniauth['provider']} authentication."
      else
        flash[:notice] = "You have already authorized your #{omniauth['provider']} account."
      end
      redirect_to current_user
    elsif auth
      flash[:notice] = "Welcome back #{omniauth['provider']} user."
      UserSession.create(auth.person, true) # Person is present. Login the person with his social account
      redirect_to current_user
    else
      flash[:notice] = "We are sorry twitter user, you must first fill in your mindapples before you can create an account."
      redirect_to new_person_path
    end
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
