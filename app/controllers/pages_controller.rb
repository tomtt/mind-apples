class PagesController < ApplicationController
  def home
    redirect_to new_respondent_path
  end
end
