# == Schema Information
#
# Table name: users
#
#  id                  :integer         not null, primary key
#  email               :string(255)     not null
#  login               :string(255)     not null
#  crypted_password    :string(255)     not null
#  password_salt       :string(255)     not null
#  persistence_token   :string(255)     not null
#  single_access_token :string(255)     not null
#  perishable_token    :string(255)     not null
#  login_count         :integer         default(0), not null
#  failed_login_count  :integer         default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  role                :string(255)
#

require 'spec_helper'

describe User do
  describe "validations" do
    before :each do
      @user = Factory.build(:user)
    end

    it "should have a valid factory by default" do
      @user.should be_valid
    end

    describe "on login" do
      it "should be required" do
        @user.login = ''
        @user.should_not be_valid
        @user.errors_on(:login).should_not be_blank
      end
      it "should be unique" do
        Factory.create(:user, :login => 'wibble')
        @user.login = 'wibble'
        @user.should_not be_valid
        @user.errors_on(:login).should_not be_blank
      end

      it "should not allow values that start with an underscore" do
        @user.login = '_mylogin'
        @user.should_not be_valid
        @user.errors_on(:login).should_not be_blank
      end

      it "should only allow alphanumeric characters" do
        non_alphanumeric = ['MyÁpples', 'With space', 'gimmethe$', 'example.com']
        non_alphanumeric.each do |invalid|
          @user.login = invalid
          @user.should_not be_valid
          @user.errors_on(:login).should_not be_blank
        end
        @user.login = 'Alpha-Num_3r1c'
        @user.should be_valid
      end

    end

    describe "on email" do
      it "should be required" do
        @user.email = ''
        @user.should_not be_valid
        @user.errors_on(:email).should_not be_blank
      end
      it "should be unique" do
        Factory.create(:user, :email => 'me@example.com')
        @user.email = 'me@example.com'
        @user.should_not be_valid
        @user.errors_on(:email).should_not be_blank
      end

      it "should look like an email address" do
        [
          "applemind.com",
          "apple@.com",
          "@mind.com",
          "asdas@mind"
        ].each do |em|
          @user.email = em
          @user.should_not be_valid
          @user.errors.on(:email).should_not be_blank
        end
        @user.email = 'me@me.com'
        @user.should be_valid
      end
    end

    describe "on password" do
      it "should be at least 4 characters long" do
        @user.password = @user.password_confirmation = 'abc'
        @user.should_not be_valid
        @user.errors.on(:password).should include("Please choose a valid password (minimum is 4 characters)")

        @user.password = @user.password_confirmation = 'abcd'
        @user.should be_valid
      end

      it "should be confirmed" do
        @user.password = 'wibble'
        @user.should_not be_valid
        @user.errors.on(:password).should_not be_blank
      end
    end
  end

  it "role should be attr_protected" do
    user = Factory.create(:user)
    user.update_attributes(:role => 'admin')
    user.role.should_not == 'admin'
  end

  describe "person association" do
    it "should have_one person" do
      user = Factory.create(:user)
      person = Factory.create(:person, :user_id => user.id)
      user.person.should == person
    end

    it "should dependant => :nullify the person" do
      user = Factory.create(:user)
      person = Factory.create(:person, :user_id => user.id)
      user.destroy
      person.reload
      person.user_id.should == nil
    end
  end

  describe "is_admin?" do
    it "is false if the user does not have a role specified" do
      Factory.build(:user, :role => nil).is_admin?.should == false
    end

    it "is true if the user has 'admin' as its role" do
      Factory.build(:user, :role => "admin").is_admin?.should == true
    end

    it "is false if the user has something else than 'admin' as its role" do
      Factory.build(:user, :role => "").is_admin?.should == false
      Factory.build(:user, :role => "user").is_admin?.should == false
      Factory.build(:user, :role => "Admin").is_admin?.should == false
    end
  end
end
