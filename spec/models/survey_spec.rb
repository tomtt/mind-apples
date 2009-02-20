require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Survey do
  it "should create a new instance given valid attributes" do
    Factory.build(:survey).should be_valid
  end

  it "should assign a private auth code to a created survey" do
    @survey = Factory.create(:survey)
    @survey.private_auth.should_not be_nil
  end

  describe "searching in responses" do
    it "does not find any surveys if none contain the phrase" do
      s1 = Factory.create(:survey, :apple_1 => "stroke something furry")
      s2 = Factory.create(:survey, :apple_2 => "do something creative")
      s3 = Factory.create(:survey, :apple_3 => "make something tasty")
      s4 = Factory.create(:survey, :apple_4 => "help create something")
      s5 = Factory.create(:survey, :apple_5 => "something lovely")
      Survey.containing_phrase("dance").should be_empty
    end

    it "finds any survey that contains the phrase" do
      s1 = Factory.create(:survey, :apple_1 => "stroke something furry")
      s2 = Factory.create(:survey, :apple_2 => "do something creative")
      s3 = Factory.create(:survey, :apple_3 => "make something tasty")
      s4 = Factory.create(:survey, :apple_4 => "help create something")
      s5 = Factory.create(:survey, :apple_5 => "something lovely")
      Survey.containing_phrase("something").should include(s1)
      Survey.containing_phrase("something").should include(s2)
      Survey.containing_phrase("something").should include(s3)
      Survey.containing_phrase("something").should include(s4)
      Survey.containing_phrase("something").should include(s5)
    end
  end
end
