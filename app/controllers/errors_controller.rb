class ErrorsController < ApplicationController
  def error404
    render_404
  end

  def error500
    raise "Deliberate error to test 500 page."
  end
end
