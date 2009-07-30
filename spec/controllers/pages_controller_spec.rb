require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PagesController do
  describe "home" do
    it "should redirect to the page to take the survey" do
      get :home
      response.should redirect_to(new_person_path)
    end
  end
end
