require File.dirname(__FILE__) + '/../../spec_helper'
require 'cucumber/formatter/stepdefs_json'

module Cucumber
  module Formatter
    describe StepdefsJson do
      describe "extracting text from regexp" do
        it "should just return a simple string" do
          StepdefsJson.extract_text_from_regexp("bla").should == "bla"
        end
        it "should ignore regexp markers" do
          StepdefsJson.extract_text_from_regexp("/bla/").should == "bla"
        end
        it "should ignore the beginning of line marker" do
          StepdefsJson.extract_text_from_regexp("/^bla/").should == "bla"
        end
        it "should ignore the end of line marker" do
          StepdefsJson.extract_text_from_regexp("/bla$/").should == "bla"
        end
        it "should replace a non-quote capture with a prompt" do
          StepdefsJson.extract_text_from_regexp('the value is "([^\"]*)"').should ==
            'the value is "??"'
        end
        it "should replace all non-quote captures with a prompt with quote unscaped" do
          StepdefsJson.extract_text_from_regexp('the value of "([^\"]*)" is "([^\"]*)"').should ==
            'the value of "??" is "??"'
        end
        it "should replace a capture with a prompt" do
          StepdefsJson.extract_text_from_regexp('the value is (.*)').should ==
            'the value is ??'
        end
        it "should replace all captures with a prompt" do
          StepdefsJson.extract_text_from_regexp('the value of (.*) is (.*)').should ==
            'the value of ?? is ??'
        end
        it "should replace all captures with a non-greedy match" do
          StepdefsJson.extract_text_from_regexp('/^I should see "([^\"]*?)" in the "([^\"]*?)"$/').should ==
            'I should see "??" in the "??"'
        end
        it "should replace all non-quote captures with a prompt with just a quote" do
          StepdefsJson.extract_text_from_regexp('the value of "([^"]*)" is "([^"]*)"').should ==
            'the value of "??" is "??"'
        end
        it "should replace all regexp args with a regexp prompt" do
          StepdefsJson.extract_text_from_regexp('it matches \/([^\/]*)\/ or \/([^\/]*)\//').should ==
            'it matches /??/ or /??/'
        end
      end
    end
  end
end
