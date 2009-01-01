require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Survey do
  before(:each) do
    @valid_attributes = {
      :apple_1 => "value for apple_1",
      :apple_2 => "value for apple_2",
      :apple_3 => "value for apple_3",
      :apple_4 => "value for apple_4",
      :apple_5 => "value for apple_5",
      :health_check => "1",
      :suggested_people => "value for suggested_people",
      :age_range => "value for age_range",
      :country => "value for country",
      :name => "value for name",
      :email => "value for email"
    }
  end

  it "should create a new instance given valid attributes" do
    Survey.create!(@valid_attributes)
  end
end
