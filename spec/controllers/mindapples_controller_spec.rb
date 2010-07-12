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

  end

end
