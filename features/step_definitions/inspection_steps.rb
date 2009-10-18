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
