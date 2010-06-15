class BlogFeedsController < ApplicationController
  # GET /blogfeeds
  # GET /blogfeeds.xml
  def index
    @blogfeeds = BlogFeed.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blogfeeds }
    end
  end

  # GET /blogfeeds/1
  # GET /blogfeeds/1.xml
  def show
    @blogfeed = BlogFeed.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @blogfeed }
    end
  end

  # GET /blogfeeds/new
  # GET /blogfeeds/new.xml
  def new
    @blogfeed = BlogFeed.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @blogfeed }
    end
  end

  # GET /blogfeeds/1/edit
  def edit
    @blogfeed = BlogFeed.find(params[:id])
  end

  # POST /blogfeeds
  # POST /blogfeeds.xml
  def create
    @blogfeed = BlogFeed.new(params[:blogfeed])

    respond_to do |format|
      if @blogfeed.save
        flash[:notice] = 'BlogFeed was successfully created.'
        format.html { redirect_to(@blogfeed) }
        format.xml  { render :xml => @blogfeed, :status => :created, :location => @blogfeed }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @blogfeed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blogfeeds/1
  # PUT /blogfeeds/1.xml
  def update
    @blogfeed = BlogFeed.find(params[:id])

    respond_to do |format|
      if @blogfeed.update_attributes(params[:blogfeed])
        flash[:notice] = 'BlogFeed was successfully updated.'
        format.html { redirect_to(@blogfeed) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blogfeed.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blogfeeds/1
  # DELETE /blogfeeds/1.xml
  def destroy
    @blogfeed = BlogFeed.find(params[:id])
    @blogfeed.destroy

    respond_to do |format|
      format.html { redirect_to(blogfeeds_url) }
      format.xml  { head :ok }
    end
  end
end
