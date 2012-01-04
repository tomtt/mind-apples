require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordResetsController do
  shared_examples_for "all actions loading a person using perishable token" do
    it "should find a user by persishable token" do
      User.expects(:find_using_perishable_token).with('param_value')
      do_request
    end

    it "should expose the found person as @user" do
      user = Factory.create(:user)
      User.stubs(:find_using_perishable_token).returns(user)
      do_request
      assigns[:user].should == user
    end

    describe "when no person was found" do
      before do
        User.stubs(:find_using_perishable_token).returns(nil)
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
      response.should redirect_to(login_path)
    end
  end

  describe "create" do
    before do
      @email = "frooble@example.com"
    end
    def do_create
      post :create, "email" => @email
    end

    context "with a matching user" do
      before :each do
        @user = Factory.create(:user, :email => @email)
      end

      it "should deliver the password_reset instructions to the user" do
        User.stubs(:find_by_email).with(@email).returns(@user)
        @user.expects(:deliver_password_reset_instructions!)
        do_create
      end

      it "should set an info message" do
        do_create
        flash[:notice].should =~ /instructions to reset your password have been emailed to you/i
      end

      it "should redirect to the root" do
        do_create
        response.should redirect_to(root_path)
      end
    end

    context "with no matching user, but a matching person" do
      it "needs to be defined"
    end

    context "with no matching user or person" do
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
        @user = Factory.create(:user)
        User.stubs(:find_using_perishable_token).returns(@user)
      end

      it "should render edit" do
        do_request
        response.should render_template(:edit)
      end
    end
  end

  describe "update" do
    def do_request
      put :update, :id => 'param_value', :user => {}
    end

    it_should_behave_like "all actions loading a person using perishable token"

    describe "when a person was found" do
      before do
        @user = Factory.create(:user, :password => 'old_password', :password_confirmation => 'old_password')
        User.stubs(:find_using_perishable_token).returns(@user)
      end

      context "with valid params" do
        def do_update
          put :update, :id => 'param_value', :user => {"password" => 'new_password', "password_confirmation" => 'new_password'}
        end

        it "should update the user's password" do
          do_update
          @user.reload
          @user.valid_password?('new_password').should be_true
        end

        it "should log the user in" do
          do_update
          ses = UserSession.find()
          ses.should_not be_nil
          ses.record.should == @user
        end

        it "should redirect to the person edit page if the user has a person" do
          person = Factory.create(:person, :user => @user)
          do_update
          response.should redirect_to(edit_person_path(person))
        end

        it "should redirect to root path if the user has no person" do
          do_update
          response.should redirect_to(root_path)
        end
      end

      context "with invalid params" do
        def do_update
          put :update, :id => 'param_value', :user => {"password" => 'new_password', "password_confirmation" => 'something_else'}
        end

        it "should not update the user's password" do
          do_update
          @user.reload
          @user.valid_password?('new_password').should be_false
          @user.valid_password?('old_password').should be_true
        end

        it "should re-render the edit page, assigning the user" do
          do_update
          response.should render_template('edit')
          assigns[:user].should == @user
        end
      end
    end
  end
end
