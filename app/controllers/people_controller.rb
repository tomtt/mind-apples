class PeopleController < ApplicationController
  resources_controller_for :people
  before_filter :set_fields_to_create_valid_person, :only => [:create]

  def create
    self.resource = new_resource
    @resource_saved = resource.save
  end

  response_for :create do |format|
    format.html do
      if @resource_saved
        login_as_new_user
        redirect_to edit_person_path(resource)
      end
    end
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
end
