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

  describe "homepage" do
    it "redirect to person/new page" do
      get :homepage
      response.should redirect_to(new_person_path)
    end

    it "create session with suggestion from params" do
      mindapples_attributes = {'0' => {"suggestion" => 'riding on the wolf'},
                               '1' => {"suggestion" =>'swiming with sharks'},
                               '2' => {"suggestion" =>'wrestling with the bears'},
                               '3' => {"suggestion" =>''},
                               '4' => {"suggestion" =>'feading lions'}
                               }

      get :homepage,  :person => {:mindapples_attributes => mindapples_attributes}
      session[:suggestions].should == mindapples_attributes
    end

  end
end
