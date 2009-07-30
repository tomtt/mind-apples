require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Gender do
  describe "label" do
    it "should be 'Female' for 'f'" do
      Gender.label('f').should == "Female"
    end
    it "should be 'Male' for 'm'" do
      Gender.label('m').should == "Male"
    end
    it "should be 'It's complication' for 'c'" do
      Gender.label('c').should == "It's complicated"
    end
  end
end
