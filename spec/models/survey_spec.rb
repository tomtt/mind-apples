require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Survey do
  it "should create a new instance given valid attributes" do
    Factory.build(:survey).should be_valid
  end

  it "should assign a private auth code to a created survey" do
    @survey = Factory.create(:survey)
    @survey.private_auth.should_not be_nil
  end
end
