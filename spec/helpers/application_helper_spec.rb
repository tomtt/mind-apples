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
      stubs(:current_user).returns person
      page_possessor(person).should == "Your"
    end

    it "should be 'Somebody's' if the person has no name for the view and he is not logged in" do
      person = mock_model(Person, :name_for_view => nil)
      stubs(:current_user).returns mock_model(Person)
      page_possessor(person).should == "Somebody's"
    end
  end
    
  describe "share_this_icons" do
    it "returns code for twitter sharing" do
      share_this_icons.should include('http://twitter.com/home?status=')
    end

    it "returns code for facebook sharing" do
      share_this_icons.should include('http://api.addthis.com/oexchange/0.8/forward/facebook/offer')
    end
  end
  
  describe "render proper error header" do
    it "for 1 error" do
      header_error_message(1).should == "Oh dear, there was a problem:"
    end

    it "for more than 1 errors" do
      header_error_message(4).should == "Oh dear, there were 4 problems:"
    end
  end
end
