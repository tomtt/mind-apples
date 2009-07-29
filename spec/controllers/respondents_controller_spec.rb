require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RespondentsController do
  describe "new" do
    before do
      @mock_respondent = mock_model(Respondent, :initialize_mindapples => nil)
    end

    it "should create a new respondent" do
      Respondent.should_receive(:new).and_return(@mock_respondent)
      get :new
    end

    it "should have the new respondent as the resource" do
      Respondent.stub!(:new).and_return @mock_respondent
      get :new
      controller.resource.should == @mock_respondent
    end

    it "should assign mind apples to the respondent" do
      Respondent.stub!(:new).and_return @mock_respondent
      @mock_respondent.should_receive(:initialize_mindapples)
      get :new
    end
  end
end
