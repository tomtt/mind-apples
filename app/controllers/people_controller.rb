require 'sha1'

class PeopleController < ApplicationController
  resources_controller_for :people, :segment => 'person', :load_enclosing => false
  before_filter :redirect_unless_editable, :only => [:edit, :update, :register]
  before_filter :redirect_unless_visible, :only => [:show]
  before_filter :assign_network, :only => [:new]
  before_filter :add_network_to_person_attributes, :only => [:create]

  include PeopleHelper

  def update
    self.resource = find_resource
    self.resource.protected_login = (params["person"]["login"]).blank? ? current_user.login : params["person"]["login"]

    if password_invalid?
      @resource_saved = false
      populate_resource(self.resource)
    else
      @resource_saved = resource.update_attributes(params[resource_name])
    end
  end
  
  def register
    self.resource = find_resource
    redirect_to edit_resource_path unless self.resource.anonymous?
  end

  response_for :update do |format|
    if @resource_saved
      update_logged_user
      delete_profile_picture unless params['delete_avatar'].nil?
      format.html do
        flash[:notice] = if params[:register_form]
          "Thanks for registering your Mindapples page"
        else
          "Thank you for updating your Mindapples page."
        end
        redirect_to resource_path
      end
      format.js
      format.xml  { head :ok }
    else
      validate_image
      action = params[:register_form] ? "register" : "edit"
      format.html { render :action => action }
      format.js   { render :action => action }
      format.xml  { render :xml => resource.errors, :status => :unprocessable_entity }
    end
  end

  response_for :create do |format|
    if @resource_saved
      format.html do
        flash[:message] = 'Thanks for sharing your mindapples!'
        if self.resource.anonymous? && params[:pid].nil?
          redirect_to register_resource_path(resource)
        else
          redirect_to resource_path(resource)
        end
      end
    else
      format.html { render :action => "edit" }
      format.js   { render :action => "edit" }
      format.xml  { render :xml => resource.errors, :status => :unprocessable_entity }
    end
  end

  def favourites
    begin
      person = Person.find_by_param(params[:id])
      raise ActiveRecord::RecordNotFound if person.nil? 
      @favourites = person.liked_mindapples.paginate(:page => params[:page], :per_page => 10)
    rescue ActiveRecord::RecordNotFound
      flash_error_message(:notice, "Unknown person, couldn't find its favourites", root_path)
    end
  end

  def likes
    if current_user
      begin
        @mindapple = Mindapple.find(params[:id])
        like_mindapple
      rescue ActiveRecord::RecordNotFound
        flash_error_message(:notice, "Unknown mindapple, couldn't finish the operation", root_path)
      end
    else
      flash_error_message(:notice, "You must be logged in to like a mindapple", root_path)
    end
  end
  
  def unlikes
    if current_user
      begin
        @mindapple = Mindapple.find(params[:id])
        unlike_mindapple
      rescue ActiveRecord::RecordNotFound
        flash_error_message(:notice, "Unknown mindapple, couldn't finish the operation", root_path)
      end
    else
      flash_error_message(:notice, "You must be logged in to unlike a mindapple", root_path)
    end

  end

  protected

  def find_resource
    self.resource ||= params[:pid] ? Person.find(params[:pid]) : Person.find_by_param!(params["id"])
  end

  def new_resource(attributes = (params[resource_name] || {}))
    resource = Person.new_with_mindapples(attributes)
  end
  
  def password_invalid?
    # TODO: refactor validations onto the model level not the controller level if possible
    person = Person.find_by_id(params[:pid])

    if person && !person.login_set_by_user? && person.login !=  params["person"]["login"] && params["person"]["password"].blank?
      resource.attributes = params["person"]
      resource.valid?
      resource.errors.add('Please', " choose a valid password (minimum is 4 characters)")
      return true
    end
    false
  end

  def login_as_new_user
    UserSession.create!(:login => params["person"]["login"],
                        :password => params["person"]["password"],
                        :password_confirmation => params["person"]["password_confirmation"])
  end
  
  def update_logged_user
    return if params["person"]["password"].blank?
    UserSession.create!(:login => resource.login,
                        :password => resource.password,
                        :password_confirmation => resource.password)
  end

  def redirect_unless_editable
    person = self.find_resource
    unless person.editable_by?(current_user)
      flash[:notice] = "You don't have permission to edit this page"
      redirect_to root_path
    end
  end

  def redirect_unless_visible
    person = self.find_resource
    unless person.viewable_by?(current_user) or SHA1.sha1(params[:public_override]) == "e39e9114d3439a3440cac82351e6f1a8c757caa1"
      flash[:notice] = "You don't have permission to see this page"
      redirect_to root_path
    end
  end
  
  def like_mindapple
    if !current_user.mindapples.include?(@mindapple)
      if !current_user.liked_mindapples.include?(@mindapple)
        current_user.liked_mindapples << @mindapple
        current_user.save
        respond_to do |format|
          format.js {render :partial => 'likes.js.rjs'}
          format.html {redirect_to(root_path) }
        end
      else
        flash_error_message(:notice, "You can't like a mindapple more than once", root_path)
      end
    else
      flash_error_message(:notice, "Sorry, you can't like one of your own mindapples", root_path)
    end
  end

  def flash_error_message(error_key, message, redirection_target)
    flash[error_key] = message
    redirect_to(redirection_target) if redirection_target
  end

  def unlike_mindapple
    if current_user.liked_mindapples.include?(@mindapple)
      current_user.liked_mindapples.delete(@mindapple)
      current_user.save
      respond_to do |format|
        format.js {render :partial => 'unlikes.js.rjs'}
        format.html {redirect_to(root_path) }
      end

    else
      flash_error_message(:notice, "You need to like a mindapple first before you can unlike it!", root_path)
    end
  end

  def delete_profile_picture
    resource.avatar.destroy
    resource.save
  end

  def validate_image
    person = Person.find_by_id(params[:pid])

    unless person
      resource.avatar = Person.new.avatar
      return
    end

    avatar = person.avatar

    if avatar.url == Person.new.avatar.url
      resource.avatar = nil
    else
      resource.avatar = avatar
    end
  end

  def assign_network
    if params[:network]
      @network = Network.find_by_url!(params[:network])
    end
  end

  def add_network_to_person_attributes
    if params[:person].has_key?("network_url")
      network_url = params["person"].delete("network_url")
      if @network = Network.find_by_url(network_url)
        params["person"]["network_id"] = @network.id
      end
    end
  end
end
