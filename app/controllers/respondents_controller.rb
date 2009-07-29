class RespondentsController < ApplicationController
  resources_controller_for :respondents

  def new_resource
    respondent = Respondent.new
    respondent.initialize_mindapples
    respondent
  end
end
