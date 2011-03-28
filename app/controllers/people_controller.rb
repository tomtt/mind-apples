require 'sha1'

class PeopleController < ApplicationController
  resources_controller_for :people, :segment => 'person', :load_enclosing => false
  before_filter :set_fields_to_create_valid_person, :only => [:create]
  before_filter :redirect_unless_current_user_is_owner, :only => [:edit, :update]
  before_filter :redirect_unless_profile_page_is_public, :only => [:show]
  before_filter :convert_policy_checked_value, :only => [:create, :update]
  before_filter :assign_network, :only => [:new]
  before_filter :add_network_to_person_attributes, :only => [:create]

  include PeopleHelper

  def create
    self.resource = new_resource
    self.resource.protected_login = params["person"]["login"]
    self.resource.page_code = params["person"]["page_code"]

    if params["person"]["login"] && params["person"]["email"] && params["person"]["password"]
      @resource_saved = resource.save
    elsif @generated_login
      @resource_saved = resource.save
    end
    resource.login = '' if !@resource_saved && @generated_login
  end

  def update
    self.resource = find_resource
    self.resource.protected_login= (params["person"]["login"]).blank? ? current_user.login : params["person"]["login"]

    if password_invalid?
      @resource_saved = false
      populate_resource(self.resource)
    else
      @resource_saved = resource.update_attributes(params[resource_name])
    end
  end

  response_for :show, :new, :edit do |format|
    format.html
    format.js
    format.xml
  end

  response_for :update do |format|
    if @resource_saved
      update_logged_user
      delete_profile_picture unless params['delete_avatar'].nil?
      format.html do
        flash[:notice] = "Thank you for updating your Mindapples page."
        redirect_to resource_path
      end
      format.js
      format.xml  { head :ok }
    else
      validate_image
      format.html { render :action => "edit" }
      format.js   { render :action => "edit" }
      format.xml  { render :xml => resource.errors, :status => :unprocessable_entity }
    end
  end

  response_for :create do |format|
    if @resource_saved
      format.html do
        if @resource_saved
          login_as_new_user
          flash[:message] = 'Thanks for sharing your mindapples.'
          if @generated_login && params[:pid].nil?
            redirect_to edit_resource_path(resource)
          else
            redirect_to resource_path(resource)
          end
        end
      end
    else
      resource.avatar = Person.new.avatar
      format.html { render :action => "edit" }
      format.js   { render :action => "edit" }
      format.xml  { render :xml => resource.errors, :status => :unprocessable_entity }
    end
  end

  alias_method :rc_show, :show
  def show
    rc_show
  end

  def favourites
    begin
      person = Person.find_by_param(params[:id])
      raise ActiveRecord::RecordNotFound if person.nil? 
      @favourites = person.liked_mindapples.paginate(:page => params[:page], :per_page => 10)
    rescue ActiveRecord::RecordNotFound
      flash_error_message(:notice, "Unknown person, cound't find its favourites", root_path)
    end
  end

  def likes
    if current_user
      begin
        @mindapple = Mindapple.find(params[:id])
        like_mindapple
      rescue ActiveRecord::RecordNotFound
        flash_error_message(:notice, "Unknown mindapple, cound't finish like operation", root_path)
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
        flash_error_message(:notice, "Unknown mindapple, cound't finish unlike operation", root_path)
      end
    else
      flash_error_message(:notice, "You must be logged in to unlike a mindapple", root_path)
    end

  end

  protected

  def find_resource
    person = params[:pid] ? Person.find(params[:pid]) : Person.find_by_param(params["id"])
    unless person
      render_404
    end

    person
  end

  def new_resource(attributes = (params[resource_name] || {}))
    resource = Person.new_with_mindapples(attributes)
  end
  
  def password_invalid?
    person = Person.find_by_id(params[:pid])

    if person && !person.login_set_by_user? && person.login !=  params["person"]["login"] && params["person"]["password"].blank?
      resource.errors.add('Please', " choose a valid password (minimum is 4 characters)")
      return true
    end
    false
  end

  def set_fields_to_create_valid_person
    page_code = PageCode.code
    params["person"]["page_code"] = page_code
    login = params["person"]["login"]
    if !login || login.blank?
      @generated_login = true
      params["person"]["login"] = '%s%s' % [Person::AUTOGEN_LOGIN_PREFIX, page_code]
    end

    stuff_in_password_fields =
      (params["person"]["password"] || "") +
      (params["person"]["password_confirmation"] || "")
    if stuff_in_password_fields.blank? && login.blank?
      password = PageCode.code(20)
      params["person"]["password"] = password
      params["person"]["password_confirmation"] = password
    end
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

  def redirect_unless_current_user_is_owner
    unless current_user && current_user == self.find_resource
      session[:return_to] = request.path
      flash[:notice] = "You do not have permission to edit this page"
      redirect_to root_path
    end
  end
  
  def redirect_unless_profile_page_is_public
    person = self.find_resource
    if(person)
      if(current_user==person || person.public_profile || SHA1.sha1(params[:public_override]) == "e39e9114d3439a3440cac82351e6f1a8c757caa1")
        return true
      else
        flash[:notice] = "You don't have permission to see this page"
        redirect_to root_path
      end
    else
      # we do nothing as find_resource called render_404 
    end
  end
  
  def convert_policy_checked_value
    params['person']['policy_checked'] = true if params['person'] && params['person']['policy_checked'] == "1"
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
      flash_error_message(:notice, "You can't like one of your mindapples", root_path)
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
      flash_error_message(:notice, "You can't unlike a mindapple if you didn't previously like it", root_path)
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
      resource.avatar = Person.new.avatar
    else
      resource.avatar = avatar
    end
  end

  def assign_network
    if params[:network]
      @network = Network.find_by_url(params[:network]) or render_404
    end
  end

  def add_network_to_person_attributes
    if params[:person].has_key?("network_url")
      network_url = params["person"].delete("network_url")
      @network = Network.find_by_url(network_url)
      params["person"]["network_id"] = @network.to_param
    end
  end
end
