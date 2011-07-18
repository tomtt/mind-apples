# == Schema Information
#
# Table name: mindapple_likings
#
#  id           :integer         not null, primary key
#  mindapple_id :integer
#  person_id    :integer
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe MindappleLiking do
  before(:each) do
    @valid_attributes = {
      :mindapple_id => 1,
      :person_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    MindappleLiking.create!(@valid_attributes)
  end
end
