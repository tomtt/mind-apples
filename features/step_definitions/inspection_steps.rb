Then /^I should see an? "([^\"]*)" text field containing "([^\"]*)"$/ do |name, value|
  response.body.should have_selector("input[type='text'][name='#{name}'][value='#{value}']")
end

Then /^I should see an? "([^\"]*)" text area containing "([^\"]*)"$/ do |name, value|
  response.body.should have_tag("textarea[name='#{name}']", :content => value)
end

Then /^I should see an? "([^\"]*)" text field$/ do |name|
  response.body.should have_tag("input[name='#{name}'][type='text']")
end

Then /^I should not see an? "([^\"]*)" text field$/ do |name|
  response.body.should_not have_tag("input[name='#{name}'][type='text']")
end

Then /^I should see an? "([^\"]*)" text area$/ do |name|
  response.body.should have_tag("textarea[name='#{name}']")
end
