class PagesController < ApplicationController

  def error
    raise 'Intentional error'
  end
end
