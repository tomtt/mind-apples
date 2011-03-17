require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PeopleImport do
  def mock_bucket_object(options = {})
    object = mock("bucket object")
    options.each do |k, v|
      object.stubs(k).returns(v)
    end
    object
  end

  describe "s3_csv_objects" do
    it "establishes an s3 connection" do
      ENV["S3_KEY"] = "abc"
      ENV["S3_SECRET"] = "123def"
      AWS::S3::Base.expects(:establish_connection!).
        with(has_entries(:access_key_id => "abc", :secret_access_key => "123def"))
      AWS::S3::Bucket.stubs(:objects).returns([])
      PeopleImport.s3_csv_objects
    end

    describe "selected objects" do
      before do
        AWS::S3::Base.stubs(:establish_connection!)
      end

      def setup_mock_object(options)
        AWS::S3::Bucket.stubs(:objects).with(PeopleImport::BUCKET).returns([mock_bucket_object(options)])
      end

      it "does not include files that are not in the directory corresponding to the current environment" do
        setup_mock_object(:key => "foo/one.csv")
        PeopleImport.s3_csv_objects.should be_empty
      end

      it "includes .csv files directly in the directory corresponding to the current environment" do
        setup_mock_object(:key => "test/two.csv")
        PeopleImport.s3_csv_objects.should_not be_empty
      end

      it "includes .CSV files directly in the directory corresponding to the current environment" do
        setup_mock_object(:key => "test/three.CSV")
        PeopleImport.s3_csv_objects.should_not be_empty
      end

      it "does not include non-csv files that have .csv somewhere in the key" do
        setup_mock_object(:key => "test/aardvark.csv.doc")
        PeopleImport.s3_csv_objects.should be_empty
      end

      it "does not include non-csv files that end with .[something]csv" do
        setup_mock_object(:key => "test/aardvark.xxcsv")
        PeopleImport.s3_csv_objects.should be_empty
      end

      it "does not include non-csv files directly in the directory corresponding to the current environment" do
        setup_mock_object(:key => "test/four.doc")
        PeopleImport.s3_csv_objects.should be_empty
      end

      it "does not include files that are in 'foo/test' if the environment is 'test'" do
        setup_mock_object(:key => "foo/test/five.csv")
        PeopleImport.s3_csv_objects.should be_empty
      end

      it "includes .CSV files in a subdirectory under the directory corresponding to the current environment" do
        setup_mock_object(:key => "test/sub1/sub2/sub3/badger.CSV")
        PeopleImport.s3_csv_objects.should_not be_empty
      end
    end
  end

  describe "s3_csv_directory" do
    it "establishes an s3 connection" do
      ENV["S3_KEY"] = "abc"
      ENV["S3_SECRET"] = "123def"
      AWS::S3::Base.expects(:establish_connection!).
        with(has_entries(:access_key_id => "abc", :secret_access_key => "123def"))
      AWS::S3::Bucket.stubs(:objects).returns([])
      PeopleImport.s3_csv_directory
    end

    it "returns just the object corresponding to the top level directory that the csv files are obtained from" do
      objects = []
      objects << mock_bucket_object(:key => "foo/")
      objects << mock_bucket_object(:key => "test/aardvark.csv")
      objects << mock_bucket_object(:key => "test/")
      AWS::S3::Bucket.stubs(:objects).with(PeopleImport::BUCKET).returns(objects)
      PeopleImport.s3_csv_directory.key.should == "test/"
    end
  end

  describe "find_csv_by_s3_key" do
    it "establishes an s3 connection" do
      ENV["S3_KEY"] = "abc"
      ENV["S3_SECRET"] = "123def"
      AWS::S3::Base.expects(:establish_connection!).
        with(has_entries(:access_key_id => "abc", :secret_access_key => "123def"))
      AWS::S3::S3Object.stubs(:find)
      PeopleImport.find_csv_by_s3_key("xyz")
    end

    it "finds the s3 object" do
      AWS::S3::Base.stubs(:establish_connection!)
      AWS::S3::S3Object.expects(:find).with("test/some_key.csv", PeopleImport::BUCKET)
      PeopleImport.find_csv_by_s3_key("test/some_key.csv")
    end
  end
end

describe "PeopleImport::S3ObjectHelpers" do
  describe "displayed_filename" do
    it "returns an objects key without the top_level directory" do
      object = AWS::S3::S3Object.new
      object.stubs(:key).returns("test/foo/bar.csv")
      object.displayed_filename.should == "foo/bar.csv"
    end
  end

  describe "last_modified" do
    it "returns a DateTime object corresponding to the S3 object's last-modified date" do
      object = AWS::S3::S3Object.new
      object.stubs(:about).returns("last-modified" => "Wed, 16 Mar 2011 15:54:54 GMT")
      object.last_modified.should == DateTime.parse("2011-03-16 15:54:54")
    end
  end
end
