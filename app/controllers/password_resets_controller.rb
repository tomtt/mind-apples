class PasswordResetsController < ApplicationController
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  # before_filter :require_no_user

  def index
    redirect_to login_url
  end
  
  def create
    @person = Person.find_by_email(params[:email])
    if @person
      @person.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +
        "Please check your email."
      redirect_to root_path
    else
      flash[:notice] = "No user was found with that email address"
      redirect_to login_path
    end
  end

  def update
    @person.password = params[:person][:password]
    @person.password_confirmation = params[:person][:password_confirmation]
    @person.save
    if @person.save
      reset_user_session
      flash[:notice] = "Password successfully updated"
      redirect_to edit_person_path(@person)
    else
      render :action => :edit
    end
  end

  private

  def load_user_using_perishable_token
    @person = Person.find_using_perishable_token(params[:id])
    unless @person
      flash[:notice] = "We're sorry, but we could not locate your account. " +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."
      redirect_to root_path
    end
  end
  
  def reset_user_session
     UserSession.create(@person, true)
  end
end
