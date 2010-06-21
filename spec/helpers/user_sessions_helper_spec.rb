require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include UserSessionsHelper

describe UserSessionsHelper do

  #Delete this example and add some real ones or delete this file
  it "return proper error message for invalid login " do
    error_messages('Login/Password combination is not valid').should == "<div class=\"errorExplanation\" id=\"errorExplanation\"><h2>Sorry, we don't recognise that username and password combination. Please try again.</h2></div>"
  end

  it "return origianal error message if error message is different than 'Login/Password combination" do
    error_messages('Login is not valid').should_not == "<div class=\"errorExplanation\" id=\"errorExplanation\"><h2>Sorry, we don't recognise that username and password combination. Please try again.</h2></div>"
  end

end
