class PeopleController < ApplicationController
  resources_controller_for :people, :segment => 'person', :load_enclosing => false
  before_filter :set_fields_to_create_valid_person, :only => [:create]
  before_filter :redirect_unless_current_user_is_owner, :only => [:edit, :update]

  def create
    self.resource = new_resource
    self.resource.protected_login = params["person"]["login"]
    self.resource.page_code = params["person"]["page_code"]
    @resource_saved = resource.save
  end

  def update
    self.resource = find_resource
    self.resource.protected_login=(params["person"]["login"])
    @resource_saved = resource.update_attributes(params[resource_name])
  end

  response_for :update do |format|
    if @resource_saved
      format.html do
        flash[:notice] = "#{resource_name.humanize} was successfully updated."
        redirect_to edit_resource_path
      end
      format.js
      format.xml  { head :ok }
    else
      format.html { render :action => "edit" }
      format.js   { render :action => "edit" }
      format.xml  { render :xml => resource.errors, :status => :unprocessable_entity }
    end
  end

  response_for :create do |format|
    format.html do
      if @resource_saved
        login_as_new_user
        redirect_to edit_person_path(resource)
      end
    end
  end

  alias_method :rc_show, :show
  def show
    rc_show
  end

  protected

  def find_resource
    Person.find_by_param(params["id"])
  end

  def new_resource(attributes = (params[resource_name] || {}))
    resource = resource_service.new attributes
    resource.ensure_corrent_number_of_mindapples
    resource
  end

  def set_fields_to_create_valid_person
    page_code = PageCode.code
    params["person"]["page_code"] = page_code
    params["person"]["login"] ||= '%s%s' % [Person::AUTOGEN_LOGIN_PREFIX, page_code]
    password = PageCode.code(20)
    params["person"]["password"] = password
    params["person"]["password_confirmation"] = password
  end

  def login_as_new_user
    UserSession.create!(:login => params["person"]["login"],
                        :password => params["person"]["password"],
                        :password_confirmation => params["person"]["password_confirmation"])
  end

  def redirect_unless_current_user_is_owner
    unless current_user && current_user == self.find_resource
      session[:return_to] = request.path
      flash[:notice] = "You do not have permission to edit this page"
      redirect_to login_path
    end
  end
end
