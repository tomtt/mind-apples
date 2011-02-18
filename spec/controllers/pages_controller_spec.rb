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

  describe "debug" do
    # No need to spec what values to set, but enabling of debug needs to be tested
    it "renders debug if DEBUG_ENABLED is TRUE" do
      ENV["DEBUG_ENABLED"] = "TRUE"
      get :debug
      response.should render_template(:debug)
    end

    it "renders debug if DEBUG_ENABLED is tRue (disregarding case)" do
      ENV["DEBUG_ENABLED"] = "tRue"
      get :debug
      response.should render_template(:debug)
    end

    it "redirects to the root if DEBUG_ENABLED is not TRUE" do
      ENV["DEBUG_ENABLED"] = "FALSE"
      get :debug
      response.should redirect_to(root_path)
    end

    it "redirects to the root if DEBUG_ENABLED is not set" do
      ENV.delete("DEBUG_ENABLED")
      get :debug
      response.should redirect_to(root_path)
    end
  end
end
