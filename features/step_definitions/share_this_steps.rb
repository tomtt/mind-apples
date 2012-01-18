Then /^I should see the social media sharing popup$/ do
  response.should have_xpath("//script[contains(., 'share_on_social_media')]")
end

Then /^I should not see the social media sharing popup$/ do
  response.should_not have_xpath("//script[contains(., 'share_on_social_media')]")
end

