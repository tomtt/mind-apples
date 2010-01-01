require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ApplicationHelper

describe ApplicationHelper do
  describe "page_possessor" do
    it "should be the person's name for the view if he has one" do
      person = mock_model(Person, :name_for_view => 'Maja de Bij')
      page_possessor(person).should == "Maja de Bij's"
    end

    it "should escape html" do
      person = mock_model(Person, :name_for_view => '2 > 1')
      page_possessor(person).should == "2 &gt; 1's"
    end

    it "should be 'Your' if the person has no name for the view and he is logged in" do
      person = mock_model(Person, :name_for_view => nil)
      stub!(:current_user).and_return person
      page_possessor(person).should == "Your"
    end

    it "should be 'Somebody's' if the person has no name for the view and he is not logged in" do
      person = mock_model(Person, :name_for_view => nil)
      stub!(:current_user).and_return mock_model(Person)
      page_possessor(person).should == "Somebody's"
    end
  end
end
