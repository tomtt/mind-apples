require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PeopleController do
  def build_mock_person
    mock_model(Person,
               :ensure_corrent_number_of_mindapples => nil,
               :save => true)
  end

  shared_examples_for "all actions finding a person" do
    it "should find a person by param value" do
      Person.should_receive(:find_by_param).with('param_value')
      do_request
    end
  end

  describe "show" do
    def do_request
      get 'show', :id => 'param_value'
    end

    it_should_behave_like "all actions finding a person"
  end

  describe "edit" do
    def do_request
      get 'edit', :id => 'param_value'
    end

    it_should_behave_like "all actions finding a person"
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
    it "should log the new person in" do
      @mock_person = build_mock_person
      Person.stub!(:new).and_return @mock_person
      UserSession.should_receive(:create!)
      post(:create, "person" => {})
    end

    it "should generate a page code" do
      PageCode.should_receive(:code).twice
      post(:create, "person" => {})
    end

    it "should assign the code as the page code" do
      PageCode.stub!(:code)
      PageCode.stub!(:code).and_return 'abzABz09'
      post(:create, "person" => {})
      controller.resource.page_code.should == 'abzABz09'
    end

    it "should assign the code as the autogen login" do
      PageCode.stub!(:code)
      PageCode.stub!(:code).and_return 'abzABz09'
      post(:create, "person" => {})
      controller.resource.login.should == '%sabzABz09' % Person::AUTOGEN_LOGIN_PREFIX
    end

    it "should use a 20 character long code for the password and confirmation" do
      PageCode.stub!(:code)
      PageCode.should_receive(:code).with(20).and_return '20charlongpass'
      post(:create, "person" => {})
      controller.resource.password.should == '20charlongpass'
      controller.resource.password_confirmation.should == '20charlongpass'
    end

    it "should not allow a constructed form to create more than five mindapples" do
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
        UserSession.stub!(:create!)
        post(:create, "person" => {})
        response.should redirect_to(edit_person_path(controller.resource))
      end
    end
  end
end
