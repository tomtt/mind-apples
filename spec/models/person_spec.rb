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
#  has_received_welcome_mail :boolean
#  public_profile            :boolean         default(TRUE)
#  policy_checked            :boolean
#  avatar_file_name          :string(255)
#  avatar_content_type       :string(255)
#  avatar_file_size          :integer
#  avatar_updated_at         :datetime
#  respondent_id             :integer
#  network_id                :integer
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

    context "on email" do
      it "should require a valid email if set" do
        [
          'applemind.com',
          'apple@.com',
          '@mind.com',
          'asdas@mind',
        ].each do |string|
          @person.email = string
          @person.should_not be_valid
          @person.errors.on(:email).should_not be_blank
        end
        @person.email = 'foo@example.com'
        @person.should be_valid
      end

      it "should skip the email format validation if not anonymous" do
        # To prevent duplication of the User error messages
        user = Factory.build(:user)
        @person.user = user
        @person.email = 'example.com' # sets email on both user and person
        @person.should_not be_valid
        @person.errors.count.should == 1 # Only the error on the user
      end

      it "should be unique" do
        Factory.create(:person, :email => 'foo@example.com')
        @person.email = 'foo@example.com'
        @person.should_not be_valid
        @person.errors.on(:email).should_not be_blank
      end

      it "should allow multiple people with blank emails" do
        Factory.create(:person, :email => '')
        @person.email = ''
        @person.should be_valid
        @person.save.should be_true
      end

      it "should skip the email uniqueness validation if not anonymous" do
        # To prevent duplication of the User error messages
        Factory.create(:person, :email => 'foo@example.com')
        user = Factory.build(:user)
        @person.user = user
        @person.email = 'foo@example.com' # sets email on both user and person
        @person.should be_valid
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

  describe "email duplication handling" do
    describe "populating email from user" do
      it "should assign the user's email to the person on save" do
        user = Factory.build(:user, :email => 'user@example.com')
        person = Factory.build(:person)
        person.user = user
        person.save!
        person.email.should == 'user@example.com'
      end
    end

    describe "forwarding email assignment to user" do
      it "should set the email on the person if anonymous" do
        person = Factory.build(:person, :email => 'foo@example.com')
        person.email = 'bar@example.com'
        person.email.should == 'bar@example.com'
      end

      it "should set the email on the associated user" do
        user = Factory.build(:user, :email => 'user@example.com')
        person = Factory.build(:person, :email => 'person@example.com')
        person.user = user
        person.email = 'bar@example.com'
        user.email.should == 'bar@example.com'
        person.email.should == 'person@example.com'
      end
    end

    describe "building a new user" do
      it "should assign the person's email to the user" do
        person = Factory.build(:person, :email => 'person@example.com')
        person.build_user
        person.user.email.should == 'person@example.com'
      end

      it "should allow passing in an email for the user" do
        person = Factory.build(:person, :email => 'person@example.com')
        person.build_user(:email => 'user@example.com')
        person.user.email.should == 'user@example.com'
      end
    end
  end

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

  describe "to_param" do
    it "should return the user's login if it has a linked user" do
      user = Factory.create(:user, :login => 'fooey')
      person = Factory.create(:person, :user => user)
      person.to_param.should == 'fooey'
    end

    it "should return the saved login, instead of any unsaved changes" do
      user = Factory.create(:user, :login => 'fooey')
      person = Factory.create(:person, :user => user)
      user.login = "fido"
      person.to_param.should == 'fooey'
    end

    it "should return the page_code prefixed with _ if it has an unsaved linked user" do
      user = Factory.build(:user, :login => 'fooey')
      person = Factory.create(:person)
      person.user = user
      person.to_param.should == "_#{person.page_code}"
    end

    it "should return the page_code prefixed with _ if it has no linked user" do
      person = Factory.create(:person)
      person.to_param.should == "_#{person.page_code}"
    end
  end

  it "should return its param value when converted to string" do
    person = Factory.create(:person)
    person.to_s.should == person.to_param
  end

  describe "finding by param" do
    context "finding by an autogenerated permalink (starts with _)" do
      before :each do
        @person = Factory.create(:person, :page_code => '1rEeIiubDiYYCNDuADjE')
      end

      it "should return the person with the matching page_code" do
        Person.find_by_param!('_1rEeIiubDiYYCNDuADjE').should == @person
      end

      it "should raise RecordNotFound if no person matches" do
        lambda do
          Person.find_by_param!('_2rEeIiubDiYYCNDuADjE')
        end.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should ignore a user with a matching login" do
        user = Factory.create(:user, :login => '2rEeIiubDiYYCNDuADjE')
        Factory.create(:person, :user => user)
        lambda do
          Person.find_by_param!('_2rEeIiubDiYYCNDuADjE')
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context "finding by a user login" do
      before :each do
        @user = Factory.create(:user, :login => 'fooey')
      end

      it "should return the person linked to the user with the matching login" do
        person = Factory.create(:person, :user => @user)
        Person.find_by_param!('fooey').should == person
      end

      it "should raise RecordNotFound if a matching user has no linked person" do
        lambda do
          Person.find_by_param!('fooey')
        end.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should raise RecordNotFound if no matching user is found" do
        lambda do
          Person.find_by_param!('notfooey')
        end.should raise_error(ActiveRecord::RecordNotFound)
      end

      it "should ignore a Person with a matching page_code" do
        Factory.create(:person, :page_code => 'notfooey')
        lambda do
          Person.find_by_param!('notfooey')
        end.should raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "anonymous?" do
    it "should be true if the person has no linked user" do
      person = Factory.create(:person)
      person.anonymous?.should == true
    end

    it "should be false if the person has a linked user" do
      user = Factory.create(:user)
      person = Factory.create(:person, :user => user)
      person.anonymous?.should == false
    end
  end

  describe "name for view" do
    it "should be nil if the person has no name and is anonymous" do
      person = Factory.build(:person,
                             :name => '',
                             :page_code => 'abcdefgh')
      person.name_for_view.should be_nil
    end

    it "should be the name if it is set" do
      person = Factory.create(:person, :name => 'Ed Bever')
      person.name_for_view.should == "Ed Bever"
    end

    it "should be the user's login if it is linked, but the name is not" do
      user = Factory.create(:user, :login => 'ed_bever')
      person = Factory.create(:person, :user => user)
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
      person = Factory.create(:person, :public_profile => false)
      person.public_profile.should == false
    end
  end

  describe "cleaning up name" do
    it "should not store a blank name" do
      Factory.create(:person, :name => '  ').name.should be_nil
    end

    it "should strip whitespace from around name" do
      Factory.create(:person, :name => '  bobby  ferret ').name.should == 'bobby  ferret'
    end
  end

  describe "empty policy_checked" do
    context "with autogenerated login" do
      it "is not valid for create action with filled/unfilled policy" do
        Factory.build(:person, :policy_checked => false).should_not be_valid
      end

      it "is valid for create action" do
        Factory.build(:person, :policy_checked => nil).should be_valid
      end

      it "is not valid for update action" do
        person = Factory.create(:person)
        person.update_attributes({:policy_checked => false}).should be_false
      end
    end

    context "with normal login" do
      before :each do
        @user = Factory.create(:user, :login => 'applesmind')
      end

      it "is not valid for create action" do
        Factory.build(:person, :user => @user, :policy_checked => false).should_not be_valid
      end

      it "is not valid for update action" do
        person = Factory.create(:person, :user => @user)
        person.update_attributes({:policy_checked => false}).should be_false
      end
    end
  end

  describe "welcome email" do
    it "should be sent when created with an email address" do
      person = Factory.build(:person, :email => 'andy@example.com')
      PersonMailer.expects(:deliver_welcome_email).with(person)
      person.save!
      person.has_received_welcome_mail.should == true
    end

    it "should not be sent when created without an email address" do
      person = Factory.build(:person, :email=> '')
      PersonMailer.expects(:deliver_welcome_email).never
      person.save!
      person.has_received_welcome_mail.should be_false
    end

    it "should be sent when an email address is set" do
      person = Factory.create(:person, :email => '')
      person.has_received_welcome_mail.should be_false
      PersonMailer.expects(:deliver_welcome_email).with(person)
      person.update_attributes!(:email => 'andy@example.com')
      person.has_received_welcome_mail.should == true
    end

    it "should not be sent when no email address is set" do
      person = Factory.create(:person, :email => '')
      PersonMailer.expects(:deliver_welcome_email).never
      person.update_attributes!(:email => '')
      person.has_received_welcome_mail.should be_false
    end

    it "should not be sent if a welcome email was already sent" do
      person = Factory.create(:person, :has_received_welcome_mail => true)
      PersonMailer.expects(:deliver_welcome_email).never
      person.update_attributes!(:email => 'aaa@example.com')
    end

    it "should not be sent if the email address is unset" do
      person = Factory.create(:person, :email => 'andy@example.com')
      PersonMailer.expects(:deliver_welcome_email).never
      person.update_attributes!(:email => '')
    end

    it "should only be sent once" do
      person = Factory.create(:person, :email => 'andy@example.com')
      PersonMailer.expects(:deliver_welcome_email).never
      person.update_attributes!(:email => 'something_else@example.com')
    end

    it "should not be sent if the person has invalid fields" do
      person = Factory.create(:person, :email => '')
      PersonMailer.expects(:deliver_welcome_email).never
      person.update_attributes(:email => 'andy@example.com', :policy_checked => false)
      person.has_received_welcome_mail.should be_false
    end

    it "should not be sent if the person was imported from survey monkey" do
      person = Factory.build(:person, :email => 'andy@example.com', :respondent_id => 123)
      PersonMailer.expects(:deliver_welcome_email).never
      person.save!
      person.has_received_welcome_mail.should be_false
    end
  end

  describe "deliver_claim_your_page_instructions" do
    it "should deliver the claim_your_page email passing self" do
      person = Factory.create(:person)
      PersonMailer.expects(:deliver_claim_your_page).with(person)
      person.deliver_claim_your_page_instructions!
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

      it "should ignore if all attributes are blank" do
        person = Factory.create(:person)
        lambda do
          person.update_attributes!("user_attributes" => {"login" => '', "email" => '', "password" => '', 'password_confirmation' => ''})
        end.should_not change(User, :count)
      end
    end
  end

  describe "permissions" do
    describe "viewable_by?" do
      it "should be true for an anonymous public profile" do
        user = Factory.create(:user)
        person = Factory.create(:person, :public_profile => true)
        person.viewable_by?(user).should == true
        person.viewable_by?(nil).should == true
      end

      it "should be true for a linked public profile" do
        user = Factory.create(:user)
        user2 = Factory.create(:user)
        person = Factory.create(:person, :user => user, :public_profile => true)
        person.viewable_by?(user2).should == true
        person.viewable_by?(nil).should == true
      end

      it "should be true for a private profile owned by the user" do
        user = Factory.create(:user)
        person = Factory.create(:person, :user => user, :public_profile => false)
        person.viewable_by?(user).should == true
      end

      it "should be false for a private profile not owned by the user" do
        user = Factory.create(:user)
        user2 = Factory.create(:user)
        person = Factory.create(:person, :user => user, :public_profile => false)
        person.viewable_by?(user2).should == false
        person.viewable_by?(nil).should == false
      end
    end

    describe "editable_by?" do
      it "should be true for an anonymous profile" do
        user = Factory.create(:user)
        person = Factory.create(:person)
        person.editable_by?(user).should == true
        person.editable_by?(nil).should == true
      end

      it "should be false for a profile owned by a different user" do
        user = Factory.create(:user)
        user2 = Factory.create(:user)
        person = Factory.create(:person, :user => user)
        person.editable_by?(user2).should == false
        person.editable_by?(nil).should == false
      end

      it "should be true for a profile owned by the user" do
        user = Factory.create(:user)
        person = Factory.create(:person, :user => user)
        person.editable_by?(user).should == true
      end
    end
  end

  describe "revert_avatar" do
    before :each do
      @person = Factory.create(:person)
    end

    it "should revert to the saved version of the avatar" do
      @person.avatar = File.open(Rails.root.join('features', 'upload-files', 'smile.jpg'))
      @person.save!
      orig_url = @person.avatar.url

      @person.avatar = File.open(Rails.root.join('features', 'upload-files', 'smile2.jpg'))
      @person.revert_avatar
      @person.avatar.url.should == orig_url
      @person.avatar.should_not be_dirty
    end

    it "should revert to the default avatar if there was no previously saved avatar" do
      orig_url = @person.avatar.url

      @person.avatar = File.open(Rails.root.join('features', 'upload-files', 'smile2.jpg'))
      @person.revert_avatar
      @person.avatar.url.should == orig_url
      @person.avatar.should_not be_dirty
    end

    it "should do nothing if the avatar is saved" do
      @person.avatar = File.open(Rails.root.join('features', 'upload-files', 'smile.jpg'))
      @person.save!
      orig_url = @person.avatar.url

      @person.revert_avatar
      @person.avatar.url.should == orig_url
      @person.avatar.should_not be_dirty
    end
  end
end
