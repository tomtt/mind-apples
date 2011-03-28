require 'spec_helper'

describe MindapplesController do

  def mock_mindapple(stubs={})
    @mock_mindapple ||= mock_model(Mindapple, stubs)
  end

  describe "GET index" do
    it "assigns all mindapples that contain searched param as @mindapples" do

      Mindapple.expects(:search_by_suggestion).with("park").returns([mock_mindapple])

      get :index, :mindapple => "park"
      assigns[:mindapples].should == [mock_mindapple]
    end

    describe "when network_id is passed" do
      it "assigns all mindapples that contain searched param AND belong to passed network as @mindapples" do
        mock_network = mock("network")
        Network.stubs(:find_by_id).returns(mock_network)
        mock_collection = mock("mock_collection", :search_by_suggestion => mock(:paginate => [:result]))
        Mindapple.stubs(:belonging_to_network).with(mock_network).returns(mock_collection)
        get :index, :mindapple => "park", :network_id => 7
        assigns[:mindapples].should == [:result]
      end

      it "assigns the network to @network" do
        Mindapple.stubs(:belonging_to_network).returns(mock(:search_by_suggestion => []))
        Network.stubs(:find_by_id).with("7").returns(:mock_network)
        get :index, :mindapple => "park", :network_id => "7"
        assigns[:network].should == :mock_network
      end
    end
  end
end
