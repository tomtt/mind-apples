require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Authentication do
  before :each do 
    @user = Factory.create(:user)
    @person = Factory.create(:person)
    @returned_hash = {"user_info" => {"name" => "Test User", "location" => "a place"}, "provider" => "Twitter", "uid" => "1234567"}
  end

  describe "user association" do
    it "should belong to a user" do
      authentication = Factory.create(:authentication, :user => @user)
      authentication.user.should == @user
    end
  end

  describe "find_from_hash" do
    it "should find the authentication from the hash returned" do
      authentication = Factory.create(:authentication, :uid => "1234567", :user => @user)
      Authentication.find_from_hash(@returned_hash).should == authentication
    end
  end

  describe "create from hash" do
    context "User" do
      it "should create a new user from the returned hash if a user does not exist" do
        auth = Authentication.create_from_hash(@returned_hash, @person)
        auth.user.login.should == "testuser"
      end

      it "should update the current user if one exists" do
        auth = Authentication.create_from_hash(@returned_hash, @person, @user)
        auth.user.should == @user
      end
    end

    context "Person" do
      it "should update the person with the user id" do
        auth = Authentication.create_from_hash(@returned_hash, @person)
        user = User.find_by_login("testuser")
        person = Person.find_by_name("Test User")
        user.person.should == person
      end
    end
    
    context "Authentication" do
      it "should create a valid authentication object from the returned hash" do
        auth = Authentication.create_from_hash(@returned_hash, @person)
        auth.should be_valid
        auth.provider.should == "Twitter"
      end
    end
  end
end
