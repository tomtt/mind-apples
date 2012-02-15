require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe AuthenticationsController do
  describe "Create action" do

    before :each do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
    end

    def do_create(params = {})
      post :create, {:authentications => @person}.merge(params)
    end
 
 
    describe "if a user has already registered without Twitter or Facebook" do
      before :each do 
        @user = Factory.create(:user)
        controller.stubs(:current_user).returns(@user)
        @person = Factory.create(:person, :user => @user)
        do_create
      end
      
      it "should redirect to person path" do
        response.should redirect_to(person_path(@person))
      end
      
      it "should display a flash notice" do
        flash[:notice].should == "Successfully added twitter authentication"
      end
      
      it "should create a new authentication object against the current user" do
        @user.authentications.count.should == 1
        @user.authentications.first.provider.should == "twitter"
      end
    end

    describe "if a user has already registered using Facebook or Twitter" do
      before :each do
        @user = Factory.create(:user)
        @authentication = Factory.create(:authentication, :provider => "twitter", :uid => "1234567", :user => @user)
        @person = Factory.create(:person, :user => @user)
        do_create
      end

      it "should redirect to person path" do
        
        response.should redirect_to(person_path(@person))
      end

      it "should set a flash message" do
        flash[:notice].should == "Welcome back"
      end
    end

    describe "if a user has not registered at all" do 
      before :each do
        @person = Factory.create(:person, :name => "Test User", :page_code => "7ZtXrpd8b0PhdckgikH")
        request.cookies['page_code'] = '7ZtXrpd8b0PhdckgikH'
        do_create(request.cookies)
      end

      it "should redirect to person path" do
        @person.reload
        response.should be_redirect
        response.should redirect_to(person_path(@person))
      end

      it "should display a flash messagge" do
        flash[:notice] == "Welcome, your account has been created."
      end

      it "should delete the cookie" do
        response.cookies['page_code'].should == nil
      end
    end
  end
end
