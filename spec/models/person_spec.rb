# == Schema Information
#
# Table name: people
#
#  id                        :integer         not null, primary key
#  name                      :string(255)
#  email                     :text
#  page_code                 :string(255)     not null
#  braindump                 :text
#  location                  :string(255)
#  gender                    :string(255)
#  age                       :string(255)
#  occupation                :string(255)
#  health_check              :string(255)
#  tags                      :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  login                     :string(255)     default(""), not null
#  crypted_password          :string(255)     default(""), not null
#  password_salt             :string(255)     default(""), not null
#  persistence_token         :string(255)     default(""), not null
#  single_access_token       :string(255)     default(""), not null
#  perishable_token          :string(255)     default(""), not null
#  login_count               :integer         default(0), not null
#  failed_login_count        :integer         default(0), not null
#  last_request_at           :datetime
#  current_login_at          :datetime
#  last_login_at             :datetime
#  current_login_ip          :string(255)
#  last_login_ip             :string(255)
#  has_received_welcome_mail :boolean
#  public_profile            :boolean         default(TRUE)
#  policy_checked            :boolean
#  password_saved            :boolean         default(FALSE)
#  avatar_file_name          :string(255)
#  avatar_content_type       :string(255)
#  avatar_file_size          :integer
#  avatar_updated_at         :datetime
#  respondent_id             :integer
#  network_id                :integer
#  role                      :string(255)
#  ethnicity                 :string(255)
#  import_s3_etag            :string(255)
#  type_description          :string(255)
#  email_opt_in              :boolean
#  shared_mindapples         :boolean         default(TRUE), not null
#  one_line_bio              :string(255)
#  user_id                   :integer
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Person do
  describe "validations" do
    before :each do
      @person = Factory.build(:person)
    end

    it "should have a valid factory" do
      @person.should be_valid
    end

    context "on pagecode" do
      it "should contain only allowed characters" do
        [
          "_underscore",
          "space space",
          "wi*r$dC.h%ar@s",
        ].each do |string|
          @person.page_code = string
          @person.should_not be_valid
          @person.errors.on(:page_code).should_not be_blank
        end
        @person.page_code = 'ALphAnuM3r1c'
        @person.should be_valid
      end

      it "should be unique" do
        Factory.create(:person, :page_code => 'wibble')
        @person.page_code = 'wibble'
        @person.should_not be_valid
        @person.errors.on(:page_code).should_not be_blank
      end
    end
  end

  describe "setting page_code" do
    it "should be generated on create if blank" do
      person = Factory.build(:person)
      person.page_code.should be_blank
      person.save!
      person.page_code.should_not be_blank
    end

    it "should take any assigned value if given" do
      person = Factory.build(:person)
      person.page_code = "wibble"
      person.save!
      person.page_code.should == "wibble"
    end

    it "should be protected from mass assign" do
      person = Factory.build(:person, :page_code => 'abcdefgh')
      person.update_attributes!(:page_code => 'dangermouse')
      person.page_code.should == 'abcdefgh'
    end
  end

  #context "validations" do
    #it "should validate length of password" do
      #us = Factory.build :person
      #us.password = "abc"
      #us.password_confirmation = "abc"
      #us.valid?
      #us.errors.should_not be_nil
      #us.errors.on(:password).should include("Please choose a valid password (minimum is 4 characters)")
    #end
  #end
  
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

  it "password_saved is false in default" do
    person = Factory(:person, :login => 'testme')
    person.password_saved.should be_false
    Person.find_by_login('testme').password_saved.should be_false
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

  describe  "uniqueness of login" do
    it "is valid if there is no same login" do
      Factory.create(:person, :login => "pluk").should be_valid
    end

    it "is invalid if there is same login" do
      Factory(:person, :login => 'pluk')
      Factory.build(:person, :login => "pluk").should_not be_valid
    end

    it "is invalid for update if ther is same login" do
      Factory(:person, :login => 'pluk')
      person = Factory(:person, :login => "applesmind", :email => 'apple@minds.com')
      person.login = 'pluk'
      person.save.should be_false
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

  describe "anonymous?" do
    
    it "should be true when login starts with Person::AUTOGEN_LOGIN_PREFIX" do
      Factory.build(:person, :login => Person::AUTOGEN_LOGIN_PREFIX + 'meh').should be_anonymous
    end
    
    it "should be false when login DOES NOT start with Person::AUTOGEN_LOGIN_PREFIX" do
      Factory.build(:person, :login => 'meh').should_not be_anonymous
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

  it "should not be valid if email doesn't contain @" do
    Factory.build(:person, :email => "applemind.com").should_not be_valid
  end

  it "should not be valid if email doesn't contain domain name" do
    Factory.build(:person, :email => "apple@.com").should_not be_valid
  end

  it "should not be valid if email doesn't contain local-part" do
    Factory.build(:person, :email => "@mind.com").should_not be_valid
  end

  it "should not be valid if email doesn't contain international domain name" do
    Factory.build(:person, :email => "asdas@mind").should_not be_valid
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

  it "should not have an error on password confirmation if no password is being set" do
    person = Factory.create(:person, :password => "blabla", :password_confirmation => "blabla")
    person.role = "user"
    person.should be_valid
  end

  describe "empty policy_checked" do
    context "with autogenerated login" do
      def autogen_login
        "#{Person::AUTOGEN_LOGIN_PREFIX}abcdefgh"
      end

      it "is not valid for create action with filled/unfilled policy" do
        Factory.build(:person, :login => autogen_login, :policy_checked => false, :page_code => 'abcdefgh').should_not be_valid
      end

      it "is valid for create action" do
        Factory.build(:person, :login => autogen_login, :policy_checked => nil, :page_code => 'abcdefgh').should be_valid
      end

      it "is not valid for update action" do
        person = Factory(:person)
        person.update_attributes({:policy_checked => false, :login => autogen_login, :page_code => 'abcdefgh'}).should be_false
      end
    end

    context "with normal login" do
      it "is not valid for create action" do
        Factory.build(:person, :login => "applesmind", :policy_checked => false).should_not be_valid
      end

      it "is not valid for update action" do
        person = Factory(:person)
        person.update_attributes({:policy_checked => false, :login => "applesmind"}).should be_false
      end
    end
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

    it "should not be sent if the person was imported from survey monkey" do
      person = Factory.build(:person, :email => 'andy@example.com', :respondent_id => 123)
      PersonMailer.expects(:deliver_welcome_email).never
      person.save!
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

  describe "don't need an email if is login autogenerated" do
    it "for creating" do
      Person.any_instance.stubs(:login_set_by_user?).returns(false)
      person1 = Factory(:person, :email => nil)
      person2 = Factory.build(:person, :email => nil)
      person2.save.should be_true
    end

    it "for editing" do
      Person.any_instance.stubs(:login_set_by_user?).returns(false)
      person1 = Factory(:person, :email => nil)
      person2 = Factory(:person, :email => nil)
      person2.save.should be_true
    end
  end

  describe "associations" do
    describe "liked mindapples" do
      it "responds to liked_mindapples method" do
        person = Factory.create(:person, :email => "person_test@email.com")
        person.respond_to?('liked_mindapples').should == true
      end

      it "returns an array of a person's liked mindapples" do
        mindapple1 = Factory.create(:mindapple)
        mindapple2 = Factory.create(:mindapple)
        person = Factory.create(:person, :email => "person_test2@email.com")

        person.liked_mindapples << mindapple1
        person.liked_mindapples << mindapple2

        person.liked_mindapples.should include(mindapple1)
        person.liked_mindapples.should include(mindapple2)
      end

    end
  end

  describe "destroying one" do
    it "destroys its mindapples" do
      person = Factory.create(:person)
      3.times { Factory.create(:mindapple, :person => person) }
      person.reload
      lambda { person.destroy }.should change(Mindapple, :count).by(-3)
    end
  end

  it "can be updated without resetting the password" do
    person = Factory.create(:person, :password => "blurb", :password_confirmation => "blurb")
    lambda { person.update_attributes!(:braindump => "Boo") }.should_not raise_error
  end

  describe "is_admin?" do
    it "is false if the person does not have a role specified" do
      Factory.build(:person, :role => nil).is_admin?.should == false
    end

    it "is true if the person has 'admin' as its role" do
      Factory.build(:person, :role => "admin").is_admin?.should == true
    end

    it "is false if the person has something else than 'admin' as its role" do
      Factory.build(:person, :role => "").is_admin?.should == false
      Factory.build(:person, :role => "user").is_admin?.should == false
      Factory.build(:person, :role => "Admin").is_admin?.should == false
    end
  end

  describe "user association" do
    it "should belong_to a user" do
      user = Factory.create(:user)
      person = Factory.create(:person, :user_id => user.id)
      person.user.should == user
    end

    it "should belong_to a unique user" do
      user = Factory.create(:user)
      person = Factory.create(:person, :user => user)
      person2 = Factory.build(:person, :user => user)
      person2.should_not be_valid
      person2.errors.on(:user_id).should_not be_blank
    end

    it "should allow multiple people without a user" do
      person = Factory.create(:person, :user => nil)
      person2 = Factory.build(:person, :user => nil)
      person2.should be_valid
      person2.save.should be_true
    end

    describe "accepting nested attributes for user" do
      it "should accept nested attributes for user" do
        user = Factory.create(:user)
        person = Factory.create(:person, :user => user)
        person.update_attributes!(:user_attributes => {:email => 'wibble@example.com'})
        user.reload
        user.email.should == 'wibble@example.com'
      end

      it "should create a new user if one doesn't exist" do
        person = Factory.create(:person)
        lambda do
          person.update_attributes!(:user_attributes => Factory.attributes_for(:user, :email => 'woo@example.com'))
        end.should change(User, :count).by(1)
        person.user.email.should == 'woo@example.com'
      end
    end
  end
end
