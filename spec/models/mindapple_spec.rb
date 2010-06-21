# == Schema Information
#
# Table name: mindapples
#
#  id         :integer(4)      not null, primary key
#  suggestion :text
#  person_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Mindapple do
  before(:each) do
    @valid_attributes = {
      :suggestion => "value for suggestion",
      :person_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Mindapple.create!(@valid_attributes)
  end
  
  describe "associations" do
    describe "people that like a mindapple" do
      it "responds to fans method" do
        mindapple = Factory.create(:mindapple)
        mindapple.respond_to?('fans').should == true
      end
      
      it "returns an array of people that like the mindapple" do
        mindapple = Factory.create(:mindapple)
        person1 = Factory.create(:person, :email => "person1@email.com") 
        person2 = Factory.create(:person, :email => "person2@email.com")
        
        person1.liked_mindapples << mindapple
        person2.liked_mindapples << mindapple
        
        mindapple.fans.should include(person1)
        mindapple.fans.should include(person2)
      end
    end
  end
end

