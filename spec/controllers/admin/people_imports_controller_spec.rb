require 'spec_helper'

describe Admin::PeopleImportsController do
  context "when logged in as admin" do
    before :each do
      @admin_person = Factory.create(:person, :role => "admin")
      login_as(@admin_person)
    end

    describe "GET new" do
      before do
        AWS::S3::Base.stubs(:establish_connection!)
        AWS::S3::Bucket.stubs(:objects).returns([])
        AWS::S3::S3Object.stubs(:find).returns(mock('s3 object'))
      end

      it "assigns the network options to @network_options" do
        Factory.create(:network, :name => "Badger", :id => 12)
        Factory.create(:network, :name => "Aardvark", :id => 8)
        Factory.create(:network, :name => "Cockatoo", :id => 10)

        get :new

        expected_options = [["--- Select a network ---", nil]]
        expected_options << ["Aardvark", 8]
        expected_options << ["Badger", 12]
        expected_options << ["Cockatoo", 10]

        assigns[:network_options].should == expected_options
      end

      it "assigns a new PeopleImport to @people_import" do
        PeopleImport.stubs(:new).returns(:a_new_model)
        get :new
        assigns[:people_import].should == :a_new_model
      end
    end

    describe "POST create" do
    end
  end
end
