class MindapplesController < ApplicationController

  def index
    @mindapples = Mindapple.search_by_suggestion(params['mindapple']).paginate(:page => params[:page], :per_page => 10) unless params['mindapple'].blank?

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mindapples }
    end
  end

end
