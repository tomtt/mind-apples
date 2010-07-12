When /^(?:|I )try to go to (.+)$/ do |page_name|
  begin
    old_rescue_value = ActionController::Base.allow_rescue
    ActionController::Base.allow_rescue = true
    # Make Rails treat the request as an external request so we get the public error handing
    header "REMOTE-ADDR", "10.0.1.1"
    When "I go to #{page_name}"
  rescue Exception
    # Swallow 500 errors and the like because that's what we need to test.
  ensure
    ActionController::Base.allow_rescue = old_rescue_value
  end
end

When /^I follow the facebook link$/ do
  # ck_facebook is the id of the ShareThis autogenerated link
  # click_link("ck_facebook")
  pending
end


When /^I follow the twitter link$/ do
  # ck_facebook is the id of the ShareThis autogenerated link
  # click_link("ck_twitter")
  pending
end

Then /^I should see "([^\"]*)" link with "([^\"]*)" url$/ do |link_text, link_url|
  response.should have_xpath("//a[@href='#{link_url}']")
  response.should have_xpath("//a[@href='#{link_url}'][text()='#{link_text}']")
end

When /^I should see "([^\"]*)" image link with "([^\"]*)" url$/ do |link_id, link_url|
  response.should have_xpath("//a[@href='#{link_url}']")
end

When /^I should see "([^\"]*)" image link$/ do |link_id|
  response.should have_xpath("//a[@id='#{link_id}']")
end

Then /^I should see homepage "([^\"]*)" section$/ do |section_name|
  response.should have_xpath("//h2[contains(.,'#{section_name}')]")
end
