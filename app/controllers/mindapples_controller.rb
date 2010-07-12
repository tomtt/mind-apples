class MindapplesController < ApplicationController
  def index
    @mindapples = Mindapple.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mindapples }
    end
  end
end
