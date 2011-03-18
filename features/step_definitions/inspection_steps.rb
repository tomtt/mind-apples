Then /^I should see an? "([^\"]*)" (text|password) field containing "([^\"]*)"$/ do |name, type, value|
  response.body.should have_selector("input[type='#{type}'][name='#{name}'][value='#{value}']")
end

Then /^I should not see an? "([^\"]*)" (text|password) field containing "([^\"]*)"$/ do |name, type, value|
  response.body.should_not have_selector("input[type='#{type}'][name='#{name}'][value='#{value}']")
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

Then /^I should see an? "([^\"]*)" submit button$/ do |name|
  response.body.should have_tag("input[name='#{name}'][type='submit']")
end

Then /^I should not see an? "([^\"]*)" submit button$/ do |name|
  response.body.should_not have_tag("input[name='#{name}'][type='submit']")
end

When /^I should see a ShareThis facebook link$/ do
  response.should have_selector("a", :id=> 'addthis_button_facebook')
end

When /^I should see a ShareThis twitter link$/ do
  response.should have_selector("a", :id=> 'addthis_button_twitter')
end

Then /^I should see the "([^\"]*)" image with alt "([^\"]*)"$/ do |image_path, alt_text|
  response.should have_xpath("//img[./@alt='#{alt_text}'][contains(./@src, '#{image_path}')]")
end

Then /^I should not see the "([^\"]*)" image with alt "([^\"]*)"$/ do |image_path, alt_text|
  response.should_not have_xpath("//img[./@alt='#{alt_text}'][contains(./@src, '#{image_path}')]")
end

Then /^I should see an? "([^\"]*)" image button$/ do |image_path|
  response.body.should have_tag("input[type=image][src*='#{image_path}']")
end

Then /^I should not see an? "([^\"]*)" image button$/ do |image_path|
  response.body.should_not have_tag("input[type=image][src*='#{image_path}']")
end

Then /^only "([^\"]*)" should be highlighted in the main menu$/ do |tab_name|
  highlighted_tabs = xpath_search("//div[@id='main_tabnav']//a[#{with_class('active')}]")
  highlighted_tabs.size.should == 1
  highlighted_tabs.first.text.should == tab_name
end
