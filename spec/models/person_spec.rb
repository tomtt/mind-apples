require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Person do
  describe "ensuring correct number of mindapples" do
    it "should assign five mindapples if it has none" do
      person = Person.new
      person.ensure_correct_number_of_mindapples
      person.should have(5).mindapples
    end

    it "should assign only up to five mindapples if it already has some" do
      person = Person.new
      3.times { person.mindapples.build }
      person.ensure_correct_number_of_mindapples
      person.should have(5).mindapples
    end

    it "should delete enough mindapples to have 5 left if it has more" do
      person = Person.new
      7.times { |i| person.mindapples.build(:created_at => i.days.ago, :suggestion => i.to_s) }
      person.ensure_correct_number_of_mindapples
      person.should have(5).mindapples
    end

    it "should return the person" do
      person = Person.new
      person.ensure_correct_number_of_mindapples.should == person
    end
  end

  describe "setting login" do
    it "should set the login if it currently is empty" do
      person = Factory.build(:person, :login => "")
      person.protected_login = 'gandy'
      person.save!
      person.login.should == 'gandy'
    end

    it "should set the login if it current has no value" do
      person = Factory.build(:person, :login => nil)
      person.protected_login = 'gandy'
      person.save!
      person.login.should == 'gandy'
    end

    it "should set the login if it's value was autogenerated " do
      person = Factory.build(:person,
                             :login => "#{Person::AUTOGEN_LOGIN_PREFIX}abcdefgh",
                             :page_code => 'abcdefgh')
      person.protected_login = 'gandy'
      person.save!
      person.login.should == 'gandy'
    end

    it "should set not change the login if it currently has a value" do
      person = Factory.build(:person, :login => "dangermouse")
      person.protected_login = 'gandy'
      person.save!
      person.login.should == 'dangermouse'
    end

    it "should be protected from mass assign" do
      person = Factory.build(:person, :login => 'gandy')
      person.update_attributes(:login => 'dangermouse')
      person.login.should == 'gandy'
    end

    it "should have an error when the login is changed to a value that starts with the autogen string" do
      person = Factory.create(:person,
                              :login => "#{Person::AUTOGEN_LOGIN_PREFIX}abcdefgh",
                              :page_code => 'abcdefgh')
      person.protected_login = "#{Person::AUTOGEN_LOGIN_PREFIX}anything"
      person.save
      person.should have(1).errors
    end

    it "should keep the original value if an attempt was made to change it to a value starting with the autogen string" do
      person = Factory.create(:person,
                              :login => "#{Person::AUTOGEN_LOGIN_PREFIX}abcdefgh",
                              :page_code => 'abcdefgh')
      person.protected_login = "#{Person::AUTOGEN_LOGIN_PREFIX}anything"
      person.save
      person.login.should == "#{Person::AUTOGEN_LOGIN_PREFIX}abcdefgh"
    end
  end

  describe "login set by user?" do
    it "should be no if no login is set" do
      Factory.build(:person, :login => nil).should_not be_login_set_by_user
    end

    it "should be no if login is blank" do
      Factory.build(:person, :login => ' ').should_not be_login_set_by_user
    end

    it "should be no if login is autogenerated" do
      person = Factory.create(:person,
                              :login => "#{Person::AUTOGEN_LOGIN_PREFIX}abcdefgh",
                              :page_code => 'abcdefgh')
      person.should_not be_login_set_by_user
    end

    it "should be yes if the login is set" do
      person = Factory.create(:person,
                              :login => "pluk")
      person.should be_login_set_by_user
    end

    it "should be no if there is an error on login" do
      person = Factory.build(:person,
                             :login => "_pluk")
      person.valid?
      person.should_not be_login_set_by_user
    end
  end

  describe "setting page_code" do
    it "should be protected from mass assign" do
      person = Factory.build(:person, :page_code => 'abcdefgh')
      person.update_attributes(:page_code => 'dangermouse')
      person.page_code.should == 'abcdefgh'
    end
  end

  describe "to_param" do
    it "should have its login as param if it has set one" do
      Factory.create(:person, :login => 'bert').to_param.should == 'bert'
    end

    it "should have its page_code as param if its login was autogenerated" do
      person = Factory.create(:person,
                              :login => '%spagecode' % Person::AUTOGEN_LOGIN_PREFIX,
                              :page_code => 'pagecode')
      person.to_param.should == '_pagecode'
    end
  end

  describe "finding by param" do
    before do
      @person = Factory.create(:person,
                               :login => 'frooble',
                               :page_code => 'wibble')
    end

    it "should find by login if the id does not start with an underscore" do
      Person.find_by_param('frooble').should == @person
    end

    it "should not find by login if the id starts with an underscore" do
      Person.find_by_param('_frooble').should be_nil
    end

    it "should find by page code if the id starts with an underscore" do
      Person.find_by_param('_wibble').should == @person
    end

    it "should not find by page code if the id does not start with an underscore" do
      Person.find_by_param('wibble').should be_nil
    end
  end

  it "should return its param value when converted to string" do
    person = Factory.create(:person)
    person.to_s.should == person.to_param
  end

  describe "name for view" do
    it "should be nil if the person has no name and an autogenerated login" do
      person = Factory.build(:person,
                             :login => "#{Person::AUTOGEN_LOGIN_PREFIX}abcdefgh",
                             :page_code => 'abcdefgh')
      person.name_for_view.should be_nil
    end

    it "should be the name if it is set" do
      person = Factory.create(:person, :name => 'Ed Bever', :login => 'ed_bever')
      person.name_for_view.should == "Ed Bever"
    end

    it "should be the login if it is set but the name is not" do
      person = Factory.create(:person, :login => 'ed_bever')
      person.name_for_view.should == "ed_bever"
    end
  end
  
  describe "public profile" do
    it "is saved as public as default" do
      person_attributes = Factory.attributes_for(:person)
      person = Person.create(person_attributes)
      person.public_profile.should == true
    end
    
    it "is saved as non public if is public_profile set to false" do
      person = Factory.create(:person, :login => 'ed_bever', :public_profile => false)
      person.public_profile.should == false
    end
  end

  it "should not be valid if it does not have a page code" do
    Factory.build(:person, :page_code => nil).should_not be_valid
  end

  it "should not be valid if its login starts with an underscore" do
    Factory.build(:person, :login => '_starts_with_underscore').should_not be_valid
  end

  it "should not be valid if its login is blank" do
    Factory.build(:person, :login => '          ').should_not be_valid
  end

  it "should not be valid if it starts with space" do
    Factory.build(:person, :login => '    bobby').should_not be_valid
  end

  it "should not store a blank name" do
    Factory.create(:person, :name => '  ').name.should be_nil
  end

  it "should strip whitespace from around name" do
    Factory.create(:person, :name => '  bobby  ferret ').name.should == 'bobby  ferret'
  end

  it "should not be valid if it does not have a blank policy_checked" do
    Factory.build(:person, :policy_checked => nil).should_not be_valid
  end

  it "should not be valid if it does not have a string policy_checked" do
    Factory.build(:person, :policy_checked => "ss").should_not be_valid
  end
  
  it "should not be valid if email is already taken" do
    person1 = Factory.create(:person, :email => "apple@mind.com")
    Factory.build(:person, :email => "apple@mind.com").should_not be_valid
  end

  it "should not update if email is already taken" do
    person1 = Factory.create(:person, :email => "apple@mind.com")
    person2 = Factory.create(:person, :email => "mind@apple.com")
    person1.update_attributes({:email => 'mind@apple.com'}).should be_false
  end

  describe "welcome email" do
    it "should be sent when created with an email address" do
      person = Factory.build(:person, :email => 'andy@example.com')
      PersonMailer.expects(:deliver_welcome_email).with(person)
      person.save!
    end

    it "should not be sent when created without an email address" do
      Person.any_instance.stubs(:login_set_by_user?).returns(false)
      person = Factory.build(:person, :email=> '')
      PersonMailer.expects(:deliver_welcome_email).never
      person.save!
    end

    it "should be sent when an email address is set" do
      Person.any_instance.stubs(:login_set_by_user?).returns(false)
      person = Factory.create(:person, :email => '')
      PersonMailer.expects(:deliver_welcome_email).with(person)
      person.update_attributes(:email => 'andy@example.com')
    end

    it "should not be sent when no email address is set" do
      person = Factory.create(:person)
      PersonMailer.expects(:deliver_welcome_email).never
      person.update_attributes(:email => '')
    end

    it "should not be sent if a welcome email was already sent" do
      person = Factory.create(:person, :has_received_welcome_mail => true)
      PersonMailer.expects(:deliver_welcome_email).never
      person.update_attributes(:email => 'aaa@example.com')
    end

    it "should not be sent if the email address is unset" do
      person = Factory.create(:person, :email => 'andy@example.com')
      PersonMailer.expects(:deliver_welcome_email).never
      person.update_attributes(:email => '')
    end

    it "should only be sent once" do
      person = Factory.create(:person, :email => 'andy@example.com')
      PersonMailer.expects(:deliver_welcome_email).never
      person.update_attributes(:email => 'something_else@example.com')
    end

    it "should not be sent if the person has invalid fields" do
      person = Factory.create(:person)
      PersonMailer.expects(:deliver_welcome_email).never
      person.update_attributes(:email => 'andy@example.com',
                               :password => 'bla1234',
                               :password_confirmation => 'foo1234')
    end
  end

  describe "delivering password reset instructions" do
    it "should reset the perishable token" do
      person = Factory.create(:person)
      person.expects(:reset_perishable_token!)
      person.deliver_password_reset_instructions!
    end

    it "should send out the email with instruction on how to set a password" do
      person = Factory.create(:person)
      PersonMailer.expects(:deliver_set_password).with(person)
      person.deliver_password_reset_instructions!
    end
  end

  describe "new with mindapples" do
    it "should have 5 mindapples" do
      person = Person.new_with_mindapples
      person.should have(5).mindapples
    end

    it "should pass attributes" do
      Person.new_with_mindapples(:name => 'samson').name.should == 'samson'
    end
  end
  
  describe "comparing emails" do
    it "return true if is new email and old email different" do
      person = Factory.create(:person, :email => 'apple@mind.com')
      person2 = Factory.build(:person, :email=> 'mind@apple.com')
      person2.unique_email?.should be_true
    end

    it "return true if only email that exists is mine" do
      person = Factory.create(:person, :email => 'apple@mind.com')
      person.unique_email?.should be_true
    end
    
    it "return false if is new email and old email same" do
      person = Factory.create(:person, :email => 'apple@mind.com')
      person2 = Factory.build(:person, :email=> 'apple@mind.com')
      person2.unique_email?.should be_false
    end
    
  end
end