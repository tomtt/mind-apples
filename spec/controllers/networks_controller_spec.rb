require 'spec_helper'

describe NetworksController do
  describe "GET show" do
    it "finds the network from the params" do
      pend_when_not_using_postgres
      Network.expects(:find_by_url).with("4beauty")
      get :show, :network => "4beauty"
    end

    it "renders a 404 if the network could not be found" do
      pend_when_not_using_postgres
      Network.stubs(:find_by_url).returns(nil)
      get :show, :network => "4beauty"
      response.should render_template('errors/error_404')
    end

    it "assign the found network to @network" do
      pend_when_not_using_postgres
      Network.stubs(:find_by_url).returns(:the_found_network)
      get :show, :network => "4beauty"
      assigns[:network].should == :the_found_network
    end

    it "assigns most liked mindapples within the network to @most_liked" do
      pending
    end

    it "assigns most recent mindapples within the network to @most_recent" do
      pending
    end
  end
end
