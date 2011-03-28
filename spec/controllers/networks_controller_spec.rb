require 'spec_helper'

describe NetworksController do
  describe "GET show" do
    it "finds the network from the params" do
      pend_when_not_using_postgres
      Network.expects(:find_by_url).with("4beauty")
      Mindapple.stubs(:most_liked_within_network).returns([])
      get :show, :network => "4beauty"
    end

    it "renders a 404 if the network could not be found" do
      pend_when_not_using_postgres
      Network.stubs(:find_by_url).returns(nil)
      Mindapple.stubs(:most_liked_within_network).returns([])
      get :show, :network => "4beauty"
      response.should render_template('errors/error_404')
    end

    it "assign the found network to @network" do
      pend_when_not_using_postgres
      Network.stubs(:find_by_url).returns(:the_found_network)
      Mindapple.stubs(:most_liked_within_network).returns([])
      get :show, :network => "4beauty"
      assigns[:network].should == :the_found_network
    end

    it "assigns most liked mindapples within the network to @most_liked" do
      pend_when_not_using_postgres
      Network.stubs(:find_by_url).returns(:the_found_network)
      most_liked_mock = [:most, :liked, :mock]
      Mindapple.stubs(:most_liked_within_network).
        with(:the_found_network, PagesController::TOP_APPLES_MAX).
        returns(most_liked_mock)
      get :show, :network => "4beauty"
      assigns[:most_liked].should == most_liked_mock
    end

    it "assigns most recent mindapples within the network to @most_recent" do
      controller.stubs(:current_user).returns(false)
      UserSession.stubs(:new).returns(:new_user_session)
      get :show, :network => "4beauty"
      assigns[:user_session].should == :new_user_session
    end

    it "does not assign @user_session if the user is already logged in" do
      controller.stubs(:current_user).returns(true)
      get :show, :network => "4beauty"
      assigns[:user_session].should == nil
    end
  end
end
