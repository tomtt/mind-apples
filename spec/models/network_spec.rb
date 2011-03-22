# == Schema Information
#
# Table name: networks
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  url         :string(255)
#  form_header :text
#  created_at  :datetime
#  updated_at  :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Network do
  it "has a factory that creates a valid instance" do
    Factory.build(:network).should be_valid
  end

  it "uses the url as its to_param" do
    Factory.build(:network, :url => "froop").to_param.should == "froop"
  end
end

