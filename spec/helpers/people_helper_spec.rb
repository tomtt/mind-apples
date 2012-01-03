require 'spec_helper'

describe PeopleHelper do
  
  describe "populate resource" do
    it "populated unsaved resource object with data from params" do
      resource = Person.new
      params[:person] = {:email => 'mind@apples.com',
                         :login => 'calm_mind',
                         :some_value => 'artifical'}

      helper.populate_resource(resource)

      resource.email.should == 'mind@apples.com'
      resource.login.should == 'calm_mind'
      resource.some_value.should == 'artifical'
    end

    it "doesn't populate empty login'" do
      resource = Person.new
      params[:person] = {:email => 'mind@apples.com',
                         :login => '',
                         :some_value => 'artifical'}

      helper.populate_resource(resource)
      resource.login.should_not == 'calm_mind'
    end
  end

  describe "person_link" do
    before :each do
      helper.stubs(:current_user).returns(nil)
    end

    it "return proper person name" do
      user = Factory.create(:user, :login => "apples_mind")
      person = Factory.create(:person, :user => user, :name => "Mind apples user", :public_profile => true)
      mindapple = Factory.create(:mindapple, :person => person)

      helper.person_link(mindapple).should == "<a href=\"/person/apples_mind\">Mind apples user</a>"
    end

    it "return login name if there is no user name" do
      user = Factory.create(:user, :login => "apples_mind")
      person = Factory.create(:person, :user => user, :name => "", :public_profile => true)
      mindapple = Factory.create(:mindapple, :person => person)

      helper.person_link(mindapple).should == "<a href=\"/person/apples_mind\">apples_mind</a>"
    end

    it "return 'anonymous' for an anonymous person" do
      person = Factory.create(:person, :user => nil, :name => "", :page_code => "asadsda", :public_profile => true)
      mindapple = Factory.create(:mindapple, :person => person)

      helper.person_link(mindapple).should == "anonymous"
    end

    it "return name without link for anonymous person with name" do
      person = Factory.create(:person, :user => nil, :name => "Andyyy", :page_code => "asadsda", :public_profile => true)
      mindapple = Factory.create(:mindapple, :person => person)

      helper.person_link(mindapple).should == "Andyyy"
    end

    it "return anonymous name without link for user with private profile" do
      user = Factory.create(:user)
      person = Factory.create(:person, :user => user, :name => "Mind apples user", :public_profile => false)
      mindapple = Factory.create(:mindapple, :person => person)

      helper.person_link(mindapple).should == "anonymous"
    end

    it "return anonymous name without link for user with private profile when logged in" do
      user = Factory.create(:user, :login => "apples_mind")
      person = Factory(:person, :user => user, :name => "Mind apples user", :public_profile => false)
      mindapple = Factory(:mindapple,:person => person)

      user2 = Factory.create(:user, :login => "someone_else")
      helper.stubs(:current_user).returns(user2)

      helper.person_link(mindapple).should == "anonymous"
    end

    it "return name with link for user with private profile when logged in as that user" do
      user = Factory.create(:user, :login => "apples_mind")
      person = Factory.create(:person, :user => user, :name => "Mind apples user", :public_profile => false)
      mindapple = Factory.create(:mindapple, :person => person)
      helper.stubs(:current_user).returns(user)

      helper.person_link(mindapple).should == "<a href=\"/person/apples_mind\">Mind apples user</a>"
    end
  end

  describe "current_user_owns_person?" do
    before :each do
      helper.stubs(:current_user).returns(nil)
      @person = Factory.build(:person)
    end

    it "should return false when not logged in" do
      helper.current_user_owns_person?(@person).should == false
    end

    it "should return false when the person is anonymous" do
      user = Factory.build(:user)
      helper.stubs(:current_user).returns(user)
      helper.current_user_owns_person?(@person).should == false
    end

    it "should return false when the person is owned by a different user" do
      user = Factory.build(:user)
      helper.stubs(:current_user).returns(user)
      @person.user = Factory.build(:user)
      helper.current_user_owns_person?(@person).should == false
    end

    it "should return true when the logged in user owns the person" do
      user = Factory.build(:user)
      helper.stubs(:current_user).returns(user)
      @person.user = user
      helper.current_user_owns_person?(@person).should == true
    end
  end

  describe "suggestion" do
    before(:each) do
      session[:suggestions] = {'0' => {"suggestion" => 'riding on the wolf'},
                               '1' => {"suggestion" =>'swiming with sharks'},
                               '2' => {"suggestion" =>'wrestling with the bears'},
                               '3' => {"suggestion" =>''},
                               '4' => {"suggestion" =>'feading lions'}
                               }
    end

    it "return suggestion from session" do
      helper.suggestion(1).should == 'swiming with sharks'
    end

    it "clear session with suggestions" do
      helper.suggestion(4).should == 'feading lions'
      session[:suggestions].should == nil
    end

  end
end
