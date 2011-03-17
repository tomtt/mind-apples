require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ModelAttributes do
  describe "construct" do
    it "produces an empty hash if keys and values are both an empty array" do
      ModelAttributes.construct([], []).should == {}
    end

    it "raises an error if the size of the keys and values arrays do not match" do
      lambda { ModelAttributes.construct([:one], [:two, :three]) }.should raise_error(ArgumentError)
    end

    it "produces a hash with the single key and value" do
      ModelAttributes.construct(["name"], ["Bob"]).should == { "name" => "Bob" }
    end

    it "produces a hash with multiple keys and values" do
      ModelAttributes.construct(["name", "age"], ["Bob", 23]).should == { "name" => "Bob", "age" => 23 }
    end

    it "nests a key that dictates a hierarchy" do
      ModelAttributes.construct(["blobs[1][foo]"], ["bar"]).should == { "blobs" => { "1" => { "foo" => "bar" } } }
    end

    it "can insert different nested keys into the same part of the hash" do
      keys = ["blobs[1][foo]", "blobs[0][foo]", "blobs[1][bar]"]
      values = ["first", "second", "third"]
      attributes = ModelAttributes.construct(keys, values)
      attributes.should == {
        "blobs" => {
          "0" => {
            "foo" => "second"
          },
          "1" => {
            "foo" => "first",
            "bar" => "third"
          }
        }
      }
    end

    it "raises an ArgumentError if a closing bracket is missing" do
      lambda { ModelAttributes.construct(["a[b"], [:foo]) }.should raise_error(ArgumentError)
    end

    it "raises an ArgumentError if an opening bracket is missing" do
      lambda { ModelAttributes.construct(["a[b"], [:foo]) }.should raise_error(ArgumentError)
    end

    it "raises an ArgumentError if the key is blank" do
      lambda { ModelAttributes.construct([""], [:foo]) }.should raise_error(ArgumentError)
    end

    it "raises an ArgumentError if one of the keys in a hierarchy is blank" do
      lambda { ModelAttributes.construct(["blobs[][foo]"], [:foo]) }.should raise_error(ArgumentError)
    end
  end
end
