require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordResetsController do
  def create_mock_person
    mock_person = mock_model(Person,
                             :password= => nil,
                             :password_confirmation= => nil,
                             :save => nil)
    mock_person
  end

  shared_examples_for "all actions loading a person using perishable token" do
    it "should find a person by persishable token" do
      Person.expects(:find_using_perishable_token).with('param_value')
      do_request
    end

    it "should expose the found person as @person" do
      mock_person = create_mock_person
      Person.stubs(:find_using_perishable_token).returns(mock_person)
      do_request
      assigns[:person].should == mock_person
    end

    describe "when no person was found" do
      before do
        Person.stubs(:find_using_perishable_token).returns nil
      end

      it "should notify the user" do
        do_request
        flash[:notice].should =~ /could not locate your account/
      end

      it "should redirect to the homepage" do
        do_request
        response.should redirect_to(root_path)
      end
    end
  end
  
  describe "index" do
    it "redirects to login" do
      get :index
      response.should be_redirect
    end
  end

  describe "create" do
    before do
      @email = "frooble@example.com"
    end

    def do_create
      post(:create, "email" => @email)
    end

    it "should find a person by email" do
      Person.expects(:find_by_email).with(@email)
      do_create
    end

    it "should expose the found person" do
      mock_person = mock_model(Person, :deliver_password_reset_instructions! => nil)
      Person.stubs(:find_by_email).returns mock_person
      do_create
      assigns[:person].should == mock_person
    end

    describe "for user with email address" do
      before do
        @mock_person = mock_model(Person, :deliver_password_reset_instructions! => nil)
        Person.stubs(:find_by_email).returns @mock_person
      end

      it "should deliver password reset instructions" do
        @mock_person.expects(:deliver_password_reset_instructions!)
        do_create
      end

      it "should notify the user that an email has been sent" do
        do_create
        flash[:notice].should =~ /instructions to reset your password have been emailed to you/i
      end

      it "should redirect to the homepage" do
        do_create
        response.should redirect_to(root_path)
      end
    end

    describe "when there is no user with email address" do
      before do
        Person.stubs(:find_by_email).returns nil
      end

      it "should notify the user that there is no such email address" do
        do_create
        flash[:notice].should =~ /no user was found/i
      end

      it "should show the login page" do
        do_create
        response.should redirect_to(login_path)
      end
    end
  end

  describe "edit" do
    def do_request
      get 'edit', :id => 'param_value'
    end

    it_should_behave_like "all actions loading a person using perishable token"

    describe "when a person was found" do
      before do
        @mock_person = mock_model(Person)
        Person.stubs(:find_using_perishable_token).returns @mock_person
      end

      it "should render edit" do
        do_request
        response.should render_template(:edit)
      end
    end
  end

  describe "update" do
    def do_request
      put :update, :id => 'param_value', :person => {}
    end

    it_should_behave_like "all actions loading a person using perishable token"

    describe "when a person was found" do
      before do
        @mock_person = create_mock_person
        Person.stubs(:find_using_perishable_token).returns @mock_person
      end

      it "should set the password and confirmation and save" do
        @mock_person.expects(:password=).with('betterpassword')
        @mock_person.expects(:password_confirmation=).with('betterpassword')
        @mock_person.expects(:save)
        put(:update,
            :id => 'param_value',
            :person => {
              :password => 'betterpassword',
              :password_confirmation => 'betterpassword'
            })
      end

      describe "when the person is saved successfully" do
        before do
          @mock_person.stubs(:save).returns true
        end

        it "should notify the user" do
          UserSession.stubs(:create)
          do_request
          flash[:notice].should =~ /password successfully updated/i
        end

        it "should redirect to the person's account editing page" do
          UserSession.stubs(:create)
          do_request
          response.should redirect_to(edit_person_path(@mock_person))
        end
        
        it "should reset the user session" do
          UserSession.expects(:create).with(@mock_person, true)

          @mock_person.expects(:password=).with('betterpassword')
          @mock_person.expects(:password_confirmation=).with('betterpassword')
          @mock_person.expects(:save).returns(true)
          
          put :update, :id => 'param_value', :person => {
              :password => 'betterpassword',
              :password_confirmation => 'betterpassword'
            }
        end
      end

      describe "when the person could not be saved" do
        before do
          @mock_person.stubs(:save).returns false
        end

        it "should render edit" do
          do_request
          response.should render_template(:edit)
        end
      end
    end
  end
end
