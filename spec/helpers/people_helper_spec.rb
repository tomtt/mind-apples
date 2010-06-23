require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include PeopleHelper

describe PeopleHelper do

  #paper clip don't return nil for blank picture
  it "return true for missing picture" do
    picture_missing?('/avatars/medium/missing.png').should == true
  end

  it "return true for missing picture" do
    picture_missing?('/avatars/medium/smile.png').should == false
  end

end
