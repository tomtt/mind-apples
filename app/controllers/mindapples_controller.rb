class MindapplesController < ApplicationController

  def index
    unless params['mindapple'].blank?
      @network = Network.find_by_id(params[:network_id])
      if params['mindapple'].size > 2
        if @network
          context = Mindapple.belonging_to_network(@network)
        else
          context = Mindapple
        end
        @mindapples = context.search_by_suggestion(params['mindapple']).paginate(:page => params[:page], :per_page => 10)
        @search_message = "Sorry, it seems that we can't find what you are looking for." if @mindapples.size == 0
      else
        @search_message = "Sorry, can you give us a little more? 3 characters or more please."
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @mindapples }
    end
  end

end
