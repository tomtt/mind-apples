class PasswordResetsController < ApplicationController
  def create
    @person = Person.find_by_email(params[:email])
    if @person
      @person.deliver_password_reset_instructions!
      flash[:notice] = "Instructions to reset your password have been emailed to you. " +
        "Please check your email."
      redirect_to root_path
    else
      flash[:notice] = "No user was found with that email address"
      render :action => :new
    end
  end
end
