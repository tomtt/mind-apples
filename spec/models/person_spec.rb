require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Person do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :email => "value for email",
      :page_code => "value for page_code",
      :braindump => "value for braindump",
      :location => "value for location",
      :gender => "value for gender",
      :age => "value for age",
      :occupation => "value for occupation",
      :health_check => "value for health_check",
      :tags => "value for tags"
    }
  end

  it "should create a new instance given valid attributes" do
    Person.create!(@valid_attributes)
  end

  describe "ensuring correct number of mindapples" do
    it "should assign five mindapples if it has none" do
      person = Person.new
      person.ensure_corrent_number_of_mindapples
      person.should have(5).mindapples
    end

    it "should assign only up to five mindapples if it already has some" do
      person = Person.new
      3.times { person.mindapples.build }
      person.ensure_corrent_number_of_mindapples
      person.should have(5).mindapples
    end

    it "should delete enough mindapples to have 5 left if it has more" do
      person = Person.new
      7.times { |i| person.mindapples.build(:created_at => i.days.ago, :suggestion => i.to_s) }
      person.ensure_corrent_number_of_mindapples
      person.should have(5).mindapples
    end
  end
end
