require 'spec_helper'

describe Admin::PeopleImportsController do
  context "when logged in as admin" do
    before :each do
      @admin_person = Factory.create(:person, :role => "admin")
      login_as(@admin_person)
    end

    describe "GET new" do
      it "assigns the network options to @network_options" do
        Factory.create(:network, :name => "Badger", :id => 12)
        Factory.create(:network, :name => "Aardvark", :id => 8)
        Factory.create(:network, :name => "Cockatoo", :id => 10)

        get :new

        expected_options = [["--- Select a network ---", "none"]]
        expected_options << ["Aardvark", 8]
        expected_options << ["Badger", 12]
        expected_options << ["Cockatoo", 10]

        assigns[:network_options].should == expected_options
      end
    end
  end
end
