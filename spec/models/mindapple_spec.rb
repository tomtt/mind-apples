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
end

