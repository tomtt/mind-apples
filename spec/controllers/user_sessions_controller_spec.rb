require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do
  def build_mock_session
    mock_model(UserSession,
               :priority_record= => nil,
               :persisting? => nil
               )
  end

  describe "create" do
    before :each do
      @user = Factory.create(:user, :login => 'wibble', :password => 'secret', :password_confirmation => 'secret')
    end

    context "with valid login" do
      def do_create(params = {})
        post :create, {:user_session => { 'login' => 'wibble', 'password' => 'secret' }}.merge(params)
      end

      it "should log the user in" do
        do_create
        ses = UserSession.find
        ses.should_not be_nil
        ses.record.should == @user
      end

      it "should log the new user in if already logged in as a different user" do
        user2 = Factory.create(:user)
        login_as(user2)
        do_create
        ses = UserSession.find
        ses.should_not be_nil
        ses.record.should == @user
      end

      it "should set a flash notice" do
        do_create
        flash[:notice].should == "Login successful!"
      end

      it "should redirect back to network path if redirect back is not set and a network was passed" do
        network = Factory.create(:network, :id => 999)
        do_create("network_id" => "999")
        response.should redirect_to(network_path(network))
      end

      it "should redirect to the person page if the user has a person" do
        person = Factory.create(:person, :user => @user)
        do_create
        response.should redirect_to(person_path(person))
      end

      it "should redirect to root path if the user has no person" do
        do_create
        response.should redirect_to(root_path)
      end
    end

    context "with invalid login" do
      def do_create
        post :create, :user_session => { 'login' => 'wibble', 'password' => 'notsecret' }
      end

      it "should not log the user in" do
        do_create
        UserSession.find.should == nil
      end

      it "should re-render the new template" do
        do_create
        response.should render_template('new')
      end

      it "should log the user out if already logged in" do
        user2 = Factory.create(:user)
        login_as(user2)
        do_create
        UserSession.find.should == nil
      end
    end
  end

  describe "destroy" do
    before do
      @user = Factory.create(:user)
      @mock_session = build_mock_session
      @mock_session.stubs(:destroy)
      @mock_session.stubs(:record).returns @user
      UserSession.stubs(:find).returns(@mock_session)
      controller.stubs(:require_user)
    end

    it "should destroy the current user session" do
      @mock_session.expects(:destroy)
      delete :destroy, "session" => {}
    end

    it "should set the flash notice with logout successful" do
      delete :destroy, "session" => {}
      flash[:notice].should == "Logout successful!"
    end

    #it "should redirect back to account path redirect back is not set" do
      #delete :destroy, "session" => {}
      #response.should redirect_to(person_path(@person))
    #end

    it "should redirect back to the user's person path if they have a linked person and redirect back is not set" do
      person = Factory.create(:person, :user => @user)
      delete :destroy, "session" => {}
      response.should redirect_to(person_path(person))
    end

    it "should redirect back to root if the uers has no person, and redirect back is not set" do
      delete :destroy, "session" => {}
      response.should redirect_to(root_path)
    end

    it "should redirect back to network path if redirect back is not set and a network was passed" do
      network = Factory.create(:network, :id => 999)
      delete :destroy, "session" => {}, "network_id" => "999"
      response.should redirect_to(network_path(network))
    end
  end
end
