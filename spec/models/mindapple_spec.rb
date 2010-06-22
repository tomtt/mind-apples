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
  
  describe "most_liked" do
    
    before(:each) do
      @mindapple_1 = Factory.create(:mindapple)
      @mindapple_2 = Factory.create(:mindapple)
      @mindapple_3 = Factory.create(:mindapple)
      @mindapple_4 = Factory.create(:mindapple)
      @mindapple_5 = Factory.create(:mindapple)
      @mindapple_6 = Factory.create(:mindapple)
      
      make_people_like_mindapple(5, @mindapple_1)
      make_people_like_mindapple(5, @mindapple_2)
      make_people_like_mindapple(3, @mindapple_3)
      make_people_like_mindapple(2, @mindapple_4)
      make_people_like_mindapple(1, @mindapple_5)      

      @max = 5
    end
        
    it "returns N mindapples if there are N or more than N in the top-N" do
      most_liked = Mindapple.most_liked(@max)
      
      most_liked.size.should == @max
    end

    it "returns the N most liked mindapples if there are N or more than N in the top-N" do
      most_liked = Mindapple.most_liked(@max)
      
      most_liked.should include(@mindapple_1)
      most_liked.should include(@mindapple_2)
      most_liked.should include(@mindapple_3)
      most_liked.should include(@mindapple_4)
      most_liked.should include(@mindapple_5)
    end

    it "doesn't return a mindapple if it's not one of the top-N" do
      most_liked = Mindapple.most_liked(@max)
      
      most_liked.should_not include(@mindapple_6)
    end
    
  end 
  
  
  def make_people_like_mindapple(number_of_fans, mindapple)
    (1..number_of_fans.to_i).each do |i|
      person = Factory.create(:person, :email=> "#{rand}_test_#{i}@email.com")
      person.liked_mindapples << mindapple        
    end
  end
end

