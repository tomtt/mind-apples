When /^I should see "([^\"]*)" field$/ do |field_name|
  response.should have_xpath("//input[@name='#{field_name}']")
end

Then /^I upload the picture "([^\"]*)"$/ do |picture_name|
  attach_file('person[avatar]', File.join(RAILS_ROOT, 'features', 'upload-files', picture_name))
end

Then /^I should see a profile picture "([^\"]*)"$/ do |image_name|
  response.should have_xpath("//img[contains(@src, '#{image_name}')]")
end

Then /^I should not see a profile picture "([^\"]*)"$/ do |image_name|
  response.should_not have_xpath("//img[contains(@src, '#{image_name}')]")
end

Then /^I (should(?: not)?) see the default profile picture$/ do |expectation|
  case expectation
   when "should"
     response.should have_xpath("//img[contains(@src, 'missing_medium.jpg') or contains(@src, 'missing_thumb.jpg')]")
   else
     response.should_not have_xpath("//img[contains(@src, 'missing_medium.jpg') or contains(@src, 'missing_thumb.jpg')]")
   end
end

Given /^profile for "([^\"]*)" with picture "([^\"]*)"$/ do |login, image_name|
  img_path = File.join(RAILS_ROOT, 'features', 'upload-files', image_name)
  Person.find_by_login(login).update_attribute(:avatar, File.new(img_path, "r"))
end

