require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PagesController do
  describe "home" do
    it "should create a new person with mindapples" do
      Person.expects(:new_with_mindapples)
      get :home
    end

    it "should assign the new person to @person" do
      Person.stubs(:new_with_mindapples).returns :new_person
      get :home
      assigns[:person].should == :new_person
    end
  end
end
