class PeopleController < ApplicationController
  resources_controller_for :people
  before_filter :set_fields_to_create_valid_person, :only => [:create]

  response_for :create do |format|
    format.html do
      if @resource_saved
        redirect_to edit_person_path(resource)
      end
    end
  end

  protected

  def new_resource(attributes = (params[resource_name] || {}))
    resource = resource_service.new attributes
    resource.ensure_corrent_number_of_mindapples
    resource
  end

  def set_fields_to_create_valid_person
    params["person"]["login"] = '_%s' % PageCode.code
    password = PageCode.code(20)
    params["person"]["password"] = password
    params["person"]["password_confirmation"] = password
  end
end
