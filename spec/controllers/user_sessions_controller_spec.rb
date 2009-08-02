require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do
  def build_mock_session
    mock_model(UserSession,
               :priority_record= => nil,
               :persisting? => nil
               )
  end

  describe "create" do
    before do
      controller.stub!(:require_no_user)
    end

    it "should log the current logged in user out" do
      @person = Factory.create(:person)
      @mock_session = build_mock_session
      @mock_session.stub!(:person).and_return @person
      UserSession.stub!(:find).and_return(@mock_session)
      @mock_session.should_receive(:destroy)
      post(:create, "session" => {})
    end

    describe "when saved" do
      before do
        @person = Factory.create(:person)
        @mock_session = build_mock_session
        @mock_session.stub!(:save).and_return true
        @mock_session.stub!(:person).and_return @person
        @mock_session.stub!(:destroy)
        UserSession.stub!(:new).and_return(@mock_session)
        UserSession.stub!(:find).and_return(@mock_session)
      end

      it "should set the flash notice with login successful" do
        post(:create, "session" => {})
        flash[:notice].should == "Login successful!"
      end

      it "should redirect back to account path redirect back is not set" do
        post(:create, "session" => {})
        response.should redirect_to(person_path(@person))
      end
    end
  end

  describe "when not saved" do
    before do
      @mock_session = build_mock_session
      @mock_session.stub!(:save).and_return false
      UserSession.stub!(:new).and_return(@mock_session)
    end

    it "should render new" do
      post(:create, "session" => {})
      response.should render_template("new")
    end
  end

  describe "destroy" do
    before do
      @person = Factory.create(:person)
      @mock_session = build_mock_session
      @mock_session.stub!(:destroy)
      @mock_session.stub!(:person).and_return @person
      UserSession.stub!(:find).and_return(@mock_session)
      controller.stub!(:require_user)
    end

    it "should destroy the current user session" do
      @mock_session.should_receive(:destroy)
      delete :destroy, "session" => {}
    end

    it "should set the flash notice with logout successful" do
      delete :destroy, "session" => {}
      flash[:notice].should == "Logout successful!"
    end

    it "should redirect back to account path redirect back is not set" do
      delete :destroy, "session" => {}
      response.should redirect_to(person_path(@person))
    end

  end
end
