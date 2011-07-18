require 'spec_helper'
require 'authlogic/test_case'

describe AuthorizationsController do
  before do
    activate_authlogic
  end
  
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
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    end
    
    context "given the user is already logged in" do
      before :each do
        controller.stubs(:current_user).returns(@person)
      end
      
      context "given an authorization exists for the current user" do
        it "should set the flash message" do
          @person.authorizations.create(:provider => 'twitter', :uid => @uid)
          get :create
          flash[:notice].should == "You have already authorized your twitter account."
          response.should redirect_to(person_path(@person))
        end
      end
      
      context "given an authorization does not exist for the current user" do
        it "should set the flash message" do
          get :create
          flash[:notice].should == "Successfully added twitter authentication."
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
          Factory.create(:authorization, :person => @person, :provider => "twitter", :uid => @uid)
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
        it "should set the flash message and redirect to the Take the test page" do
          get :create
          flash[:notice].should == "We are sorry twitter user, you must first fill in your mindapples before you can create an account."
          response.should redirect_to(new_person_path)
        end
      end
    end
  end
end