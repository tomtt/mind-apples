require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PeopleController do
  def build_mock_person
    mock_person = mock_model(Person,
                             :ensure_correct_number_of_mindapples => nil,
                             :protected_login= => nil,
                             :page_code= => nil,
                             :save => true,
                             :update_attributes => true)
    mock_person
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
    describe "when logged in as the user" do
      before do
        @mock_person = build_mock_person
        controller.stub!(:current_user).and_return @mock_person
        Person.stub!(:find_by_param).and_return(@mock_person)
      end

      def do_request
        get 'edit', :id => 'param_value'
      end

      it_should_behave_like "all actions finding a person"
    end

    describe "when not logged in" do
      before do
        @mock_person = build_mock_person
        @mock_person.stub!(:to_param).and_return('some_login')
        controller.stub!(:current_user).and_return nil
        Person.stub!(:find_by_param).with('some_login').and_return(@mock_person)
      end

      it "should set the return_to session value to the path for editing this user" do
        get 'edit', :id => 'some_login'
        session[:return_to].should == edit_person_path(@mock_person)
      end
    end
  end

  describe "update" do
    describe "when logged in as the updated user" do
      before do
        @mock_person = build_mock_person
        controller.stub!(:current_user).and_return @mock_person
        Person.stub!(:find_by_param).and_return @mock_person
      end

      it "should set the login in a protected way on the updated resource" do
        Person.stub!(:find_by_param).and_return @mock_person
        # @mock_person.stub!(:valid_password?).and_return true
        # @mock_person.stub!(:changed?).and_return false
        # @mock_person.stub!(:last_request_at)
        # @mock_person.stub!(:last_request_at=)
        # @mock_person.stub!(:persistence_token)
        @mock_person.should_receive(:update_attributes)
        @mock_person.should_receive(:protected_login=).with('gandy')
        put(:update, "person" => {"login" => 'gandy'})
      end

      it "should redirect to the show page" do
        put(:update, "person" => {"login" => 'gandy'})
        response.should redirect_to(person_path(@mock_person))
      end

      it "should flash a thank you message" do
        put(:update, "person" => {"login" => 'gandy'})
        flash[:notice].should =~ /thank you/i
      end
    end

    describe "when logged in as a different user as the updated one" do
      before do
        @logged_in_person = build_mock_person
        controller.stub!(:current_user).and_return @logged_in_person
        @mock_person = build_mock_person
        Person.stub!(:find_by_param).and_return @mock_person
      end

      it "should not update any attributes of the updated user" do
        @mock_person.should_not_receive(:update_attributes)
        put(:update, "person" => {"login" => 'gandy'})
      end

      it "should not update the login of the updated user" do
        @mock_person.should_not_receive(:protected_login=)
        put(:update, "person" => {"login" => 'gandy'})
      end

      it "should set the notice flash" do
        put(:update, "person" => {"login" => 'gandy'})
        flash[:notice].should == 'You do not have permission to edit this page'
      end

      it "should redirect to the login page" do
        put(:update, "person" => {"login" => 'gandy'})
        response.should redirect_to(login_path)
      end
    end
  end

  describe "new" do
    before do
      @mock_person = build_mock_person
    end

    it "should create a new person with mindapples" do
      Person.should_receive(:new_with_mindapples)
      get :new
    end

    it "should have the new person as the resource" do
      Person.stub!(:new_with_mindapples).and_return @mock_person
      get :new
      controller.resource.should == @mock_person
    end
  end

  describe "create" do
    it "should log the new person in" do
      @mock_person = build_mock_person
      Person.stub!(:new_with_mindapples).and_return @mock_person
      UserSession.should_receive(:create!)
      post(:create, "person" => {})
    end

    it "should generate a page code" do
      PageCode.should_receive(:code).twice
      post(:create, "person" => {})
    end

    it "should assign the code as the page code" do
      @mock_person = build_mock_person
      Person.stub!(:new_with_mindapples).and_return @mock_person
      UserSession.stub!(:create!)
      PageCode.stub!(:code).and_return 'abzABz09'
      @mock_person.should_receive(:page_code=).with('abzABz09')
      post(:create, "person" => {})
    end

    it "should set the login in a protected way on the created resource" do
      @mock_person = build_mock_person
      Person.stub!(:new_with_mindapples).and_return @mock_person
      Person.stub!(:find).and_return @mock_person
      @mock_person.stub!(:valid_password?).and_return true
      @mock_person.stub!(:changed?).and_return false
      @mock_person.stub!(:last_request_at)
      @mock_person.stub!(:last_request_at=)
      @mock_person.stub!(:persistence_token)
      @mock_person.should_receive(:protected_login=).with('gandy')
      post(:create, "person" => {"login" => 'gandy'})
    end

    it "should generate a login if the login field is blank" do
      PageCode.stub!(:code).and_return('genlogin')
      UserSession.should_receive(:create!).with hash_including(:login => Person::AUTOGEN_LOGIN_PREFIX + 'genlogin')
      post(:create, "person" => {"login" => ''})
    end

    it "should assign the code as the autogen login if no login was passed" do
      PageCode.stub!(:code)
      PageCode.stub!(:code).and_return 'abzABz09'
      post(:create, "person" => {})
      controller.resource.login.should == '%sabzABz09' % Person::AUTOGEN_LOGIN_PREFIX
    end

    it "should use a 20 character long code for the password and confirmation" do
      PageCode.stub!(:code).and_return 'abcdef'
      PageCode.should_receive(:code).with(20).and_return '20charlongpass'
      post(:create, "person" => {})
      controller.resource.password.should == '20charlongpass'
      controller.resource.password_confirmation.should == '20charlongpass'
    end

    it "should not set a default password if the password field was filled in" do
      post(:create, "person" => { :password => 'mypass' })
      controller.resource.password.should == 'mypass'
    end

    it "should not set a default password if the password confirmation field was filled in" do
      post(:create, "person" => { :password_confirmation => 'mypass' })
      controller.resource.password_confirmation.should == 'mypass'
    end

    it "should set a default password if the password field was passed blank" do
      PageCode.stub!(:code).and_return 'default_password'
      post(:create, "person" => { :password => '' })
      controller.resource.password.should == 'default_password'
    end

    it "should set a default password if the password confirmation field was passed blank" do
      PageCode.stub!(:code).and_return 'default_password'
      post(:create, "person" => { :password_confirmation => '' })
      controller.resource.password_confirmation.should == 'default_password'
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
        Person.stub!(:new_with_mindapples).and_return(@mock_person)
      end

      it "should redirect to show page" do
        UserSession.stub!(:create!)
        post(:create, "person" => {})
        response.should redirect_to(person_path(controller.resource))
      end
    end
  end
end
