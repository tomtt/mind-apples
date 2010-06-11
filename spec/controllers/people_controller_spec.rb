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
      Person.expects(:find_by_param).with('param_value')
      do_request
    end
  end

  def do_request
    get 'show', :id => 'param_value'
  end

  describe "show" do
    it_should_behave_like "all actions finding a person"
  end

  describe "edit" do
    describe "when logged in as the user" do
      before do
        @mock_person = build_mock_person
        controller.stubs(:current_user).returns @mock_person
        Person.stubs(:find_by_param).returns(@mock_person)
      end

      it_should_behave_like "all actions finding a person"
    end

    describe "when not logged in" do
      before do
        @mock_person = build_mock_person
        @mock_person.stubs(:to_param).returns('some_login')
        controller.stubs(:current_user).returns nil
        Person.stubs(:find_by_param).with('some_login').returns(@mock_person)
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
        controller.stubs(:current_user).returns @mock_person
        Person.stubs(:find_by_param).returns @mock_person
      end

      it "should set the login in a protected way on the updated resource" do
        Person.stubs(:find_by_param).returns @mock_person
        PeopleController.any_instance.stubs(:password_invalid?).returns false
        @mock_person.expects(:update_attributes)
        @mock_person.expects(:protected_login=).with('gandy')

        put(:update, "person" => {"login" => 'gandy', 'email' => 'gandy@post.com'})
      end

      it "should redirect to the show page" do
        PeopleController.any_instance.stubs(:password_invalid?)
        PeopleController.any_instance.stubs(:update_logged_user)
        put(:update, "person" => {"login" => 'gandy', 'password' => 'asdasds'})
        response.should redirect_to(person_path(@mock_person))
      end

      it "should flash a thank you message" do
        PeopleController.any_instance.stubs(:password_invalid?)
        put(:update, "person" => {"login" => 'gandy'})
        flash[:notice].should =~ /thank you/i
      end
      
      it "don't allow save blank password" do
        @mock_person.expects(:login_set_by_user?).returns true
        @mock_person.expects(:errors)
        put(:update, "person" => {"login" => 'gandy', 'password' => '', 'password_confirmation' => ''})
      end
      
      it "find resource only for existed login" do
        nil_person = mock('nil_person', :nil? => true)
        Person.stubs(:find_by_param).returns(nil_person)
        mock_person = mock('person')
        ApplicationController.any_instance.stubs(:current_user).returns(mock_person)
        
        put(:update, "person" => {"login" => 'gandy', 'password' => 'topsecret', 'password_confirmation' => 'topsecret'})
      end
    end
    
    describe "udpate logged user and reset the session" do
      before(:each) do
        @person = Factory(:person, :login => 'gandy', 'password' => 'topsecret', 'password_confirmation' => 'topsecret')
        controller.stubs(:current_user).returns @person
        Person.stubs(:find_by_param).returns @person
      end
      
      it "update user session on update" do
        PeopleController.any_instance.stubs(:password_invalid?).returns false
        controller.expects(:update_logged_user)
        put(:update, "person" => {"login" => 'gandy'})
      end
      
      it "set new user session if password was updated" do
        UserSession.expects(:create!).once.with(
                    :login => 'gandy',
                    :password => 'topsecret',
                    :password_confirmation => 'topsecret')
        put(:update, "person" => {"login" => 'gandy', 'password' => 'topsecret', 'password_confirmation' => 'topsecret'})
      end
    end

    describe "when logged in as a different user as the updated one" do
      before do
        @logged_in_person = build_mock_person
        controller.stubs(:current_user).returns @logged_in_person
        @mock_person = build_mock_person
        Person.stubs(:find_by_param).returns @mock_person
      end

      it "should not update any attributes of the updated user" do
        @mock_person.expects(:update_attributes).never
        put(:update, "person" => {"login" => 'gandy'})
      end

      it "should not update the login of the updated user" do
        @mock_person.expects(:protected_login=).never
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
      Person.expects(:new_with_mindapples)
      get :new
    end

    it "should have the new person as the resource" do
      Person.stubs(:new_with_mindapples).returns @mock_person
      get :new
      controller.resource.should == @mock_person
    end
  end

  describe "create" do
    it "should log the new person in" do
      @mock_person = build_mock_person
      Person.stubs(:new_with_mindapples).returns @mock_person
      UserSession.expects(:create!)
      post(:create, "person" => {:login => 'appleBrain', :password => 'supersecret', :email => 'my@email.com'})
    end

    it "should generate a page code" do
      PageCode.expects(:code).twice
      post(:create, "person" => {})
    end

    it "should assign the code as the page code" do
      @mock_person = build_mock_person
      Person.stubs(:new_with_mindapples).returns @mock_person
      UserSession.stubs(:create!)
      PageCode.stubs(:code).returns 'abzABz09'
      @mock_person.expects(:page_code=).with('abzABz09')
      post(:create, "person" => {})
    end

    it "should set the login in a protected way on the created resource" do
      @mock_person = build_mock_person
      Person.stubs(:new_with_mindapples).returns @mock_person
      Person.stubs(:find).returns @mock_person
      @mock_person.stubs(:valid_password?).returns true
      @mock_person.stubs(:changed?).returns false
      @mock_person.stubs(:last_request_at)
      @mock_person.stubs(:last_request_at=)
      @mock_person.stubs(:persistence_token)
      @mock_person.expects(:protected_login=).with('gandy')
      post(:create, "person" => {"login" => 'gandy'})
    end

    it "should generate a login if the login field is blank" do
      PageCode.stubs(:code).returns('genlogin')
      UserSession.expects(:create!).with has_entries(:login => Person::AUTOGEN_LOGIN_PREFIX + 'genlogin')
      post(:create, "person" => {"login" => ''})
    end

    it "should assign the code as the autogen login if no login was passed" do
      PageCode.stubs(:code)
      PageCode.stubs(:code).returns 'abzABz09'
      post(:create, "person" => {})
      controller.resource.login.should == '%sabzABz09' % Person::AUTOGEN_LOGIN_PREFIX
    end

    it "should use a 20 character long code for the password and confirmation" do
      PageCode.stubs(:code).returns 'abcdef'
      PageCode.expects(:code).with(20).returns '20charlongpass'
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

    it "should not set a default password if the login field was filled in" do
      post(:create, "person" => { :login => 'mypass' })
      controller.resource.password.should == nil
    end

    it "should set a default password if the password field was passed blank" do
      PageCode.stubs(:code).returns 'default_password'
      post(:create, "person" => { :password => '' })
      controller.resource.password.should == 'default_password'
    end

    it "should set a default password if the password confirmation field was passed blank" do
      PageCode.stubs(:code).returns 'default_password'
      post(:create, "person" => { :password_confirmation => '' })
      controller.resource.password_confirmation.should == 'default_password'
    end

    # it "don't validate email presence and uniquenes together" do
    #   person = Factory(:person)
    #   post(:create, "person" => { :email => '' })
    #   flash.now[:message].should == 'noo'
    # end
    
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
    
    describe "validate policy checkbox" do
      it "if is not checked" do
        post(:create, "person" => {'email' => 'petr@petr.com'})
        params['person']['policy_checked'].should == nil
      end
      
      it "if is checked" do
        post(:create, "person" => {'email' => 'petr@petr.com', 'policy_checked' => true})
        params['person']['policy_checked'].should == true
      end
      
      it "if is not from registration form" do
        post(:create, "person" => {})
        params['person']['policy_checked'].should == true
      end
    end
    
    describe "if user name is filled" do
      it "only with filled email" do
        person = mock('person', {:protected_login= => 'login', :page_code= => 'pagecode'})
        Person.stubs(:new_with_mindapples).returns(person)
        person.expects(:save).never
        post(:create, "person" => {'login' => 'bigapple', 'password' => 'supersecret'})
      end
      
      it "only with filled password" do
        person = mock('person', {:protected_login= => 'login', :page_code= => 'pagecode'})
        Person.stubs(:new_with_mindapples).returns(person)
        person.expects(:save).never
        post(:create, "person" => {'login' => 'bigapple', 'email' => 'my@email.com', 'password' => nil})
      end
    end
    
    describe "when saved" do
      before do
        @mock_person = build_mock_person
        @mock_person.stubs(:save).returns true
        Person.stubs(:new_with_mindapples).returns(@mock_person)
      end

      it "should redirect to show page" do
        UserSession.stubs(:create!)
        post(:create, "person" => {:login => 'appleBrain', :password => 'supersecret', :email => 'my@email.com'})
        response.should redirect_to(person_path(controller.resource))
      end
      
      it "renders flash message" do
        UserSession.stubs(:create!)
        post(:create, "person" => {:login => 'appleBrain', :password => 'supersecret', :email => 'my@email.com'})
        flash.now[:message].should == 'Thank you for registering'
      end
    end

    describe "when there are errors" do
      before do
        @mock_person = build_mock_person
        @mock_person.stubs(:save).returns false
        Person.stubs(:new_with_mindapples).returns(@mock_person)
      end

      it "should render 'edit'" do
        post(:create, "person" => {})
        response.should render_template('edit')
      end
      
      it "render 404 error page" do
        get :show, :id => 'something'
        response.should render_template('errors/error_404')
      end
    end
  end
end
