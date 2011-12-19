require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe ApplicationController do
  # We can not call the application controller directly, use a dummy
  class DummiesController < ApplicationController
    before_filter :require_no_user, :only => :something_only_for_logged_out_users
    before_filter :require_user, :only => :something_private

    def index; render :text => 'foo'; end
    def something_only_for_logged_out_users; render :text => 'hello'; end
    def something_private; render :text => 'shh. secret'; end
    def authenticated
      current_user
      render :text => 'foo'
    end
  end

  controller_name 'dummies'

  before(:all) do
    ActionController::Routing::Routes.draw do |map|
      map.resources :dummies
    end
  end

  after(:all) do
    ActionController::Routing::Routes.reload!
  end

  describe "current user session" do
    it "should find the current user session" do
      UserSession.expects(:find)
      get 'authenticated'
    end

    it "should expose the current user session as @current_user_session" do
      mock_user_session = mock_model(UserSession, :person => nil)
      UserSession.expects(:find).returns(mock_user_session)
      get 'authenticated'
      assigns[:current_user_session].should == mock_user_session
    end

    it "should find the current user" do
      mock_user_session = mock_model(UserSession, :person => :mock_user)
      UserSession.expects(:find).returns(mock_user_session)
      mock_user_session.expects(:person)
      get 'authenticated'
    end

    it "should expose the current user as @current_user" do
      mock_user_session = mock_model(UserSession, :person => :mock_user)
      UserSession.expects(:find).returns(mock_user_session)
      get 'authenticated'
      assigns[:current_user].should == :mock_user
    end
  end

  describe "logged_in?" do
    it "should be true if current_user returns a user" do
      controller.stubs(:current_user).returns(:a_user)
      controller.send(:logged_in?).should == true
    end

    it "should be false if current_user returns nil" do
      controller.stubs(:current_user).returns(nil)
      controller.send(:logged_in?).should == false
    end
  end

  describe "require user" do
    describe "when not logged in" do
      before do
        UserSession.expects(:find).returns nil
      end

      it "should store the current location" do
        get 'something_private'
        session[:return_to].should == request.request_uri
      end

      it "should store a flash stating you need to be logged in" do
        get 'something_private'
        flash[:notice].should =~ /must be logged in/
      end

      it "should redirect to the login path" do
        get 'something_private'
        response.should redirect_to(login_path)
      end
    end

    describe "when logged in" do
      before do
        UserSession.expects(:find).returns mock_model(UserSession, :person => :mock_user)
      end

      it "should render 'shh. secret'" do
        get 'something_private'
        response.body.should have_text('shh. secret')
      end
    end
  end

  describe "require no user" do
    describe "when not logged in" do
      before do
        UserSession.expects(:find).returns nil
      end

      it "should render 'hello'" do
        get 'something_only_for_logged_out_users'
        response.body.should have_text('hello')
      end
    end

    describe "when logged in" do
      before do
        UserSession.expects(:find).returns mock_model(UserSession, :person => :mock_user)
      end

      it "should store the current location" do
        get 'something_only_for_logged_out_users'
        session[:return_to].should == request.request_uri
      end

      it "should store a flash stating you need to be logged out" do
        get 'something_only_for_logged_out_users'
        flash[:notice].should =~ /must be logged out/
      end

      it "should redirect to the login path" do
        get 'something_only_for_logged_out_users'
        response.should redirect_to(root_path)
      end
    end
  end

  describe "redirect back or default" do
    class DummiesController
      def redirect_test
        redirect_back_or_default(root_path)
      end
    end

    it "should redirect to the return to value if set in the session" do
      session[:return_to] = new_person_path
      get 'redirect_test'
      response.should redirect_to(new_person_path)
    end

    it "should redirect to the default value if none set in the session" do
      get 'redirect_test'
      response.should redirect_to(root_path)
    end
  end

  # describe "catch standard errors" do
  #   it "when is raised error 500" do
  #     get :show, :id => 'something'
  #     response.should render_template('errors/error_500')
  #   end
  # end
end
