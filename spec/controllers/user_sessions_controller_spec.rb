require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do
  def build_mock_session
    mock_model(UserSession,
               :priority_record= => nil,
               :persisting? => nil
               )
  end

  describe "create" do
    describe "when saved" do
      before do
        @mock_session = build_mock_session
        @mock_session.stub!(:save).and_return true
        UserSession.stub!(:new).and_return(@mock_session)
      end

      it "should redirect back to account path redirect back is not set" do
        post(:create, "session" => {})
        response.should redirect_to(person_path(current_user))
      end
    end
  end
end
