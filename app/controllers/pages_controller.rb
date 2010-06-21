class PagesController < ApplicationController
  def home
    @person = Person.new_with_mindapples
    @blogfeeds = BlogFeed.latest(3)
  end

  def error
    raise 'Intentional error'
  end
end
