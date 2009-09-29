class PagesController < ApplicationController
  def home
    redirect_to new_person_path
  end

  def error
    raise 'Intentional error'
  end
end
