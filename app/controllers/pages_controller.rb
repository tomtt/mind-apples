class PagesController < ApplicationController
  def home
    @person = Person.new_with_mindapples
  end

  def error
    raise 'Intentional error'
  end
end
