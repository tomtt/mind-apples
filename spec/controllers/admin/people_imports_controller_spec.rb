require 'spec_helper'

describe Admin::PeopleImportsController do
  context "when logged in as admin" do
    before :each do
      @admin_person = Factory.create(:user, :role => "admin")
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
      it "initializes a PeopleImport with passed params" do
        PeopleImport.expects(:new).with("foo" => "bar").returns(mock("PeopleImport", :save => true))
        post :create, "people_import" => { "foo" => "bar" }
      end

      it "initializes a blank PeopleImport when no params were passed" do
        PeopleImport.expects(:new).with({}).returns(mock("PeopleImport", :save => true))
        post :create
      end

      context "when the people_import was saved" do
        before :each do
          @mock_people_import = mock("PeopleImport", :save => true)
          PeopleImport.stubs(:new).returns(@mock_people_import)
        end

        it "assigns the initialized PeopleImport to @people_import" do
          post :create, "people_import" => { "foo" => "bar" }
          assigns[:people_import].should == @mock_people_import
        end

        it "sets the flash notice if the people_import was saved" do
          post :create, "people_import" => { "foo" => "bar" }
          flash[:notice].should =~ /completed/
        end

        it "renders :create if the people_import was saved" do
          post :create, "people_import" => { "foo" => "bar" }
          response.should render_template(:create)
        end
      end

      context "when the people_import could not be saved" do
        before :each do
          AWS::S3::Base.stubs(:establish_connection!)
          AWS::S3::S3Object.stubs(:find).returns(mock('s3 object'))
          @mock_people_import = mock("PeopleImport", :save => false, :s3_key => "abcd")
          PeopleImport.stubs(:new).returns(@mock_people_import)
        end

        it "renders :new if the people_import was not saved" do
          post :create, "people_import" => { "foo" => "bar" }
          response.should render_template(:new)
        end

        it "sets the network options" do
          post :create, "people_import" => { "foo" => "bar" }
          assigns[:network_options].should_not be_empty
        end

        it "assigns the csv object found from the s3_key to @csv_object" do
          PeopleImport.stubs(:find_csv_by_s3_key).with("abcd").returns(:mock_csv_object)
          post :create, "people_import" => { "foo" => "bar" }
          assigns[:csv_object].should == :mock_csv_object
        end
      end
    end
  end
end
