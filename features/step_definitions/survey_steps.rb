Given /I am on the survey page/ do
  visit "/survey"
end

Then /^there should exist a survey whose "(.*)" is "(.*)"$/ do |field, value|
  @survey = Survey.find(:first, :conditions => ["#{field} = ?", value])
  @survey.should_not be_nil
end

Then /^I should be redirected to the survey's private url$/ do
  response.body.should =~ /private page for your survey/m
end
