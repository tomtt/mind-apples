require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RespondentsController do
  def build_mock_respondent
    mock_model(Respondent, :initialize_mindapples => nil)
  end

  describe "new" do
    before do
      @mock_respondent = build_mock_respondent
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

  describe "create" do
    it "should generate a page code" do
      PageCode.should_receive(:code)
      post(:create, "respondent" => {})
    end

    it "should assign the page code to the respondent" do
      PageCode.stub!(:code).and_return 'abzABz09'
      post(:create, "respondent" => {})
      controller.resource.page_code.should == 'abzABz09'
    end

    describe "when saved" do
      before do
        @mock_respondent = build_mock_respondent
        @mock_respondent.stub!(:save).and_return true
        Respondent.stub!(:new).and_return(@mock_respondent)
      end

      it "should redirect to edit page" do
        post(:create, "respondent" => {})
        response.should redirect_to(edit_respondent_path(controller.resource))
      end
    end
  end
end
