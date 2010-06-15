require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
#generated tests
describe BlogFeedsController do

  def mock_blogfeed(stubss={})
    @mock_blogfeed ||= mock_model(BlogFeed, stubss)
  end

  describe "GET index" do
    it "assigns all blogfeeds as @blogfeeds" do
      BlogFeed.stubs(:find).with(:all).returns([mock_blogfeed])
      get :index
      assigns[:blogfeeds].should == [mock_blogfeed]
    end
  end

  describe "GET show" do
    it "assigns the requested blogfeed as @blogfeed" do
      BlogFeed.stubs(:find).with("37").returns(mock_blogfeed)
      get :show, :id => "37"
      assigns[:blogfeed].should equal(mock_blogfeed)
    end
  end

  describe "GET new" do
    it "assigns a new blogfeed as @blogfeed" do
      BlogFeed.stubs(:new).returns(mock_blogfeed)
      get :new
      assigns[:blogfeed].should equal(mock_blogfeed)
    end
  end

  describe "GET edit" do
    it "assigns the requested blogfeed as @blogfeed" do
      BlogFeed.stubs(:find).with("37").returns(mock_blogfeed)
      get :edit, :id => "37"
      assigns[:blogfeed].should equal(mock_blogfeed)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created blogfeed as @blogfeed" do
        BlogFeed.stubs(:new).with({'these' => 'params'}).returns(mock_blogfeed(:save => true))
        post :create, :blogfeed => {:these => 'params'}
        assigns[:blogfeed].should equal(mock_blogfeed)
      end

      # it "redirects to the created blogfeed" do
      #   BlogFeed.stubs(:new).returns(mock_blogfeed(:save => true))
      #   post :create, :blogfeed => {}
      #   response.should redirect_to(blogfeed_url(mock_blogfeed))
      # end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved blogfeed as @blogfeed" do
        BlogFeed.stubs(:new).with({'these' => 'params'}).returns(mock_blogfeed(:save => false))
        post :create, :blogfeed => {:these => 'params'}
        assigns[:blogfeed].should equal(mock_blogfeed)
      end

      it "re-renders the 'new' template" do
        BlogFeed.stubs(:new).returns(mock_blogfeed(:save => false))
        post :create, :blogfeed => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested blogfeed" do
        BlogFeed.expects(:find).with("37").returns(mock_blogfeed)
        mock_blogfeed.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :blogfeed => {:these => 'params'}
      end

      it "assigns the requested blogfeed as @blogfeed" do
        BlogFeed.stubs(:find).returns(mock_blogfeed(:update_attributes => true))
        put :update, :id => "1"
        assigns[:blogfeed].should equal(mock_blogfeed)
      end

      # it "redirects to the blogfeed" do
      #   BlogFeed.stubs(:find).returns(mock_blogfeed(:update_attributes => true))
      #   put :update, :id => "1"
      #   response.should redirect_to(blogfeed_url(mock_blogfeed))
      # end
    end

    describe "with invalid params" do
      it "updates the requested blogfeed" do
        BlogFeed.expects(:find).with("37").returns(mock_blogfeed)
        mock_blogfeed.expects(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :blogfeed => {:these => 'params'}
      end

      it "assigns the blogfeed as @blogfeed" do
        BlogFeed.stubs(:find).returns(mock_blogfeed(:update_attributes => false))
        put :update, :id => "1"
        assigns[:blogfeed].should equal(mock_blogfeed)
      end

      it "re-renders the 'edit' template" do
        BlogFeed.stubs(:find).returns(mock_blogfeed(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested blogfeed" do
      BlogFeed.expects(:find).with("37").returns(mock_blogfeed)
      mock_blogfeed.expects(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the blogfeeds list" do
      BlogFeed.stubs(:find).returns(mock_blogfeed(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(blogfeeds_url)
    end
  end

end
