class PagesController < ApplicationController
  def home
    redirect_to new_person_path
  end
end
