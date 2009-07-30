require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PeopleController do
  def build_mock_person
    mock_model(Person, :ensure_corrent_number_of_mindapples => nil)
  end

  describe "new" do
    before do
      @mock_person = build_mock_person
    end

    it "should create a new person" do
      Person.should_receive(:new).and_return(@mock_person)
      get :new
    end

    it "should have the new person as the resource" do
      Person.stub!(:new).and_return @mock_person
      get :new
      controller.resource.should == @mock_person
    end

    it "should assign mind apples to the person" do
      Person.stub!(:new).and_return @mock_person
      @mock_person.should_receive(:ensure_corrent_number_of_mindapples)
      get :new
    end
  end

  describe "create" do
    it "should generate a page code" do
      PageCode.should_receive(:code)
      post(:create, "person" => {})
    end

    it "should assign the page code to the person" do
      PageCode.stub!(:code).and_return 'abzABz09'
      post(:create, "person" => {})
      controller.resource.page_code.should == 'abzABz09'
    end

    it "should not allow a constructed form to create more than five mindapples" do
      pending
      post(:create, "person" =>
           {
             "mindapples_attributes" =>
             {
               "0" => {"suggestion" => "apple"},
               "1" => {"suggestion" => "banana"},
               "2" => {"suggestion" => "coconut"},
               "3" => {"suggestion" => "date"},
               "4" => {"suggestion" => "elderberry"},
               "5" => {"suggestion" => "fig"}
             }
           })
      controller.resource.mindapples.size.should == 5
    end

    describe "when saved" do
      before do
        @mock_person = build_mock_person
        @mock_person.stub!(:save).and_return true
        Person.stub!(:new).and_return(@mock_person)
      end

      it "should redirect to edit page" do
        post(:create, "person" => {})
        response.should redirect_to(edit_person_path(controller.resource))
      end
    end
  end
end
