require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordResetsController do
  describe "create" do
    before do
      @email = "frooble@example.com"
    end

    def do_create
      post(:create, "email" => @email)
    end

    it "should find a person by email" do
      Person.should_receive(:find_by_email).with(@email)
      do_create
    end

    it "should expose the found person" do
      mock_person = mock_model(Person, :deliver_password_reset_instructions! => nil)
      Person.stub!(:find_by_email).and_return mock_person
      do_create
      assigns[:person].should == mock_person
    end

    describe "for user with email address" do
      before do
        @mock_person = mock_model(Person, :deliver_password_reset_instructions! => nil)
        Person.stub!(:find_by_email).and_return @mock_person
      end

      it "should deliver password reset instructions" do
        @mock_person.should_receive(:deliver_password_reset_instructions!)
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
        Person.stub!(:find_by_email).and_return nil
      end

      it "should notify the user that there is no such email address" do
        do_create
        flash[:notice].should =~ /no user was found/i
      end

      it "should show the form again" do
        do_create
        response.should render_template('new')
      end
    end
  end
end
