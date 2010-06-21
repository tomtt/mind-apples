Given /^mind apple feed from the url "([^\"]*)"$/ do |feed_url|
  FakeWeb.register_uri(:any, feed_url, :body => @xml)
  @xml_filename = File.join(Rails.root, 'spec', 'test_data', 'feed.xml')
  @xml = File.read(@xml_filename)
end

Given /^mind apple feed is consumed$/ do
  BlogFeed.destroy_all
  BlogFeed.import_feeds
end

Then /^I should see "([^\"]*)" with "([^\"]*)" url at news section$/ do |link_text, link_url|
  response.should have_xpath("//a[@href='#{link_url}']")
  response.should have_xpath("//a[@href='#{link_url}'][text()='#{link_text}']")
end


Then /^I should see (\d+) news items$/ do |number|
  document = Webrat::XML.xml_document(response.body)
  nodes = document.xpath("//*[@class='news']")
  nodes.size.should == number.to_i
end

Then /^first news contains image \(if present\)$/ do
end
