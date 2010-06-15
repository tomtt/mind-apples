Given /^mind apple feed from the file "([^\"]*)"$/ do |filename|
  @xml_filename = File.join(Rails.root, 'spec', 'test_data', filename)
  @xml = File.read(@xml_filename)
end

Given /^mind apple feed is consumed$/ do
  FakeWeb.register_uri(:any, "http://mindapples.org/feed", :body => @xml)
  BlogFeed.import_feeds
end

Then /^I should see "([^\"]*)" with "([^\"]*)" url$/ do |arg1, arg2|
end
