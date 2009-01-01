require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe SurveysController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "surveys", :action => "index").should == "/surveys"
    end
  
    it "should map #new" do
      route_for(:controller => "surveys", :action => "new").should == "/surveys/new"
    end
  
    it "should map #show" do
      route_for(:controller => "surveys", :action => "show", :id => 1).should == "/surveys/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "surveys", :action => "edit", :id => 1).should == "/surveys/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "surveys", :action => "update", :id => 1).should == "/surveys/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "surveys", :action => "destroy", :id => 1).should == "/surveys/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/surveys").should == {:controller => "surveys", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/surveys/new").should == {:controller => "surveys", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/surveys").should == {:controller => "surveys", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/surveys/1").should == {:controller => "surveys", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/surveys/1/edit").should == {:controller => "surveys", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/surveys/1").should == {:controller => "surveys", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/surveys/1").should == {:controller => "surveys", :action => "destroy", :id => "1"}
    end
  end
end
