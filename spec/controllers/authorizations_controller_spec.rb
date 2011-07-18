require 'spec_helper'

describe AuthorizationsController do

  describe "create" do
    before :each do
      @person = Factory.create(:person)
      @uid = '123456790'
      OmniAuth.config.add_mock(:twitter, {
        :user_info => {
          :name => "Joe Smith",
          :nickname => 'joesmith'
        },
        :uid => @uid
      })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter] # = {
    end
    
    context "given the user is already logged in" do
      before :each do
        controller.stubs(:current_user).returns(@person)
      end
      
      context "given an authorization exists for the current user" do
        it "should set the flash message" do
          get :create
          flash[:notice].should == "You have already authorized your twitter account"
          response.should redirect_to(person_path(@person))
        end
      end
      
      context "given an authorization does not exist for the current user" do
        it "should set the flash message" do
          get :create
          flash[:notice].should == "Successfully added twitter authentication"
          response.should redirect_to(person_path(@person))
        end
        
        it "should add an authorization to the user" do
          get :create
          @person.reload
          @person.authorizations.find_by_provider_and_uid("twitter", @uid).should_not be_nil
          response.should redirect_to(person_path(@person))
        end
      end
    end
    
    context "given the user is not already logged in" do
      before :each do
        controller.stubs(:current_user).returns(false)
      end
      
      context "given an authorization exists with the correct uid and provider" do
        before :each do
          current_user.authorizations.expects.(:create).with(:provider => "twitter", :uid => @uid)
        end
        
        it "should set the flash message" do
          get :create
          flash[:notice].should == "Welcome back twitter user."
          response.should redirect_to(person_path(@person))
        end
        
        it "should set the user session" do
          get :create
          current_user.should_not be_nil
          response.should redirect_to(person_path(@person))
        end
      end
      
      context "given an authorization cannot be found with the correct uid and provider" do
        it "should create the user"
        it "should create an authorization for the user"
        it "should set the user session"
      end
    end
    
    
    
    
    
    
    
    
    
    context "if the the user is already logged in" do
      it "should create an authorization for the current user" do
        controller.expects(:current_user).times(3).returns(@person)
        get :create
        @person.reload
        @person.authorizations.find_by_provider_and_uid("twitter", @uid).should_not be_nil
        response.should redirect_to(person_path(@person))
      end
      
      it "should set the flash notice" do
        controller.expects(:current_user).times(3).returns(@person)
        post :create
        flash[:notice].should == "Successfully added twitter authentication"
        response.should redirect_to(person_path(@person))
      end
      
    end
  
    context "if the user is not logged in" do
      context "and the user exists in the database" do
        it "should set the flash notice" do
          flash[:notice].should == "Welcome back Twitter user"
        end
      
        it "should create a user session with the user in the database"
      end
    
      context "and the user does not exist in the database" do
        it "should set the flash notice" do
          flash[:notice].should == "Welcome Twitter user. Your account has been created."
        end
      
        it "should create a new user with the details from the provider"
        it "should create a user session with the new user"
      end
    end
  end
end