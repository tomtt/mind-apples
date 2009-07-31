require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')


describe ApplicationController do
  # We can not call the application controller directly, use a dummy
  class DummiesController < ApplicationController
    def index; render :text => 'foo'; end
    def authenticated
      current_user
      render :text => 'foo'
    end
  end

  controller_name 'dummies'

  before(:all) do
    ActionController::Routing::Routes.draw do |map|
      map.resources :dummies
    end
  end

  after(:all) do
    load File.join(RAILS_ROOT, 'config', 'routes.rb')
  end

  describe "current user session" do
    it "should find the current user session" do
      UserSession.should_receive(:find)
      get 'authenticated'
    end

    it "should expose the current user session as @current_user_session" do
      mock_user_session = mock_model(UserSession, :user => nil)
      UserSession.stub!(:find).and_return(mock_user_session)
      get 'authenticated'
      assigns[:current_user_session].should == mock_user_session
    end

    it "should find the current user" do
      mock_user_session = mock_model(UserSession, :user => :mock_user)
      UserSession.stub!(:find).and_return(mock_user_session)
      mock_user_session.should_receive(:user)
      get 'authenticated'
    end

    it "should expose the current user as @current_user" do
      mock_user_session = mock_model(UserSession, :user => :mock_user)
      UserSession.stub!(:find).and_return(mock_user_session)
      get 'authenticated'
      assigns[:current_user].should == :mock_user
    end
  end
end
