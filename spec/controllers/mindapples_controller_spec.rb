require 'spec_helper'

describe MindapplesController do

  def mock_mindapple(stubs={})
    @mock_mindapple ||= mock_model(Mindapple, stubs)
  end

  describe "GET index" do
    it "assigns all mindapples as @mindapples" do
      Mindapple.stubs(:find).with(:all).returns([mock_mindapple])
      get :index
      assigns[:mindapples].should == [mock_mindapple]
    end
  end

end
