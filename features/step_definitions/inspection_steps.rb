Then /^I should see an? "([^\"]*)" (text|password) field containing "([^\"]*)"$/ do |name, type, value|
  response.body.should have_selector("input[type='#{type}'][name='#{name}'][value='#{value}']")
end

Then /^I should see an? "([^\"]*)" text area containing "([^\"]*)"$/ do |name, value|
  response.body.should have_tag("textarea[name='#{name}']", :content => value)
end

Then /^I should see an? "([^\"]*)" (text|password) field$/ do |name, type|
  response.body.should have_tag("input[name='#{name}'][type='#{type}']")
end

Then /^I should not see an? "([^\"]*)" (text|password) field$/ do |name, type|
  response.body.should_not have_tag("input[name='#{name}'][type='#{type}']")
end

Then /^I should see an? "([^\"]*)" text area$/ do |name|
  response.body.should have_tag("textarea[name='#{name}']")
end

Then /^I should see a link to "([^\"]*)"$/ do |link_href|
  response.should have_tag("a", :attributes => { :href => link_href })
end

Then /^I should not see a link to "([^\"]*)"$/ do |link_href|
  xpath = "//a[@href='#{link_href}']"
  response.should_not have_xpath(xpath)
end

Then /^I should see an? "([^\"]*)" select field with "([^\"]*)" selected$/ do |field, value|
  field_labeled(field).element.search(".//option[@selected = 'selected']").inner_html.should =~ /#{value}/
end

Then /^the response status should be (\d+)$/ do |code|
  response.code.should == code
end

Then /^"([^\"]*)" should be selected from the "([^\"]*)" options$/ do |value, field_name|
  checked_inputs = xpath_search("//input[@name='#{field_name}'][@checked='checked']")
  checked_inputs.size.should == 1
  checked_inputs.first['value'].should == value
end

When /^I should see a ShareThis facebook link$/ do
  response.should have_selector("a", :class=> 'addthis_button_facebook')
end

When /^I should see a ShareThis twitter link$/ do
  response.should have_selector("a", :class=> 'addthis_button_twitter')
end
