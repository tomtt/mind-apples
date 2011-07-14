# == Schema Information
#
# Table name: authorizations
#
#  id         :integer         not null, primary key
#  provider   :string(255)
#  uid        :string(255)
#  person_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Authorization do
  
  describe "validations" do
    before(:each) do
      @authorization = Factory.build(:authorization)
    end
    
    it "should have a valid factory by default" do
      @authorization.should be_valid
    end
    
    it "should require person_id" do
      @authorization.person_id = nil
      @authorization.should_not be_valid
      @authorization.errors_on(:person_id).should_not be_nil
    end
    
    it "should require uid" do
      @authorization.uid = nil
      @authorization.should_not be_valid
      @authorization.errors_on(:uid).should_not be_nil
    end
    
    it "should require a valid provider" do
      Authorization::VALID_PROVIDERS.each do |provider|
        @authorization.provider = provider
        @authorization.should be_valid
      end
      @authorization.provider = 'something_else'
      @authorization.should_not be_valid
      @authorization.errors_on(:provider).should_not be_nil
    end
    
    it "should have a unique pair of provider, uid and person_id" do
      @authorization.save!
      authorization_2 = Factory.build(:authorization,
        :uid => @authorization.uid,
        :provider => @authorization.provider,
        :person_id => @authorization.person_id
      )
      authorization_2.should_not be_valid
      authorization_2.errors_on(:base).should_not be_nil
    end

  end
  
  describe "associations" do
    before :each do
      @authorization = Factory.create(:authorization)
    end
    
    it "should belong to a person" do
      person = Factory.create(:person)
      @authorization.person = person
      @authorization.save!
      @authorization.reload
      @authorization.person.should == person
    end
    
  end
end
