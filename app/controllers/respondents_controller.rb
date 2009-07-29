class RespondentsController < ApplicationController
  resources_controller_for :respondents
  before_filter :populate_page_code, :only => [:create]

  protected

  def new_resource(attributes = (params[resource_name] || {}))
    resource = resource_service.new attributes
    resource.initialize_mindapples
    resource
  end

  def populate_page_code
    params["respondent"]["page_code"] = PageCode.code
  end
end
