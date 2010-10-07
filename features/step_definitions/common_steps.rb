Then /^debugger$/ do
  debugger
end

Then "show me the page body in a rails context in a browser" do
  File.open(File.join(RAILS_ROOT, 'public', "tmp.html"),"w") do |f|
    f.puts response.body
  end
  system "open http://mindapples.local/tmp.html"
end

Then /^I should get a "(\d+) ([^"]+)" response$/ do |http_status, message|
  response.status.should == "#{http_status} #{message}"
end

Given /^I fill all mandatory fields$/ do
  And "I check \"person_policy_checked\""
  And "I fill in \"person[password]\" with \"sosocial\""
  And "I fill in \"person[password_confirmation]\" with \"sosocial\""
  And "I fill in \"E-mail us\" with \"andy@example.com\""
end

Then /^I should see (\d+) mindapples$/ do |number|
  document = Webrat::XML.xml_document(response.body)
  nodes = document.xpath("//*[@class='mindapple']")
  nodes.size.should == number.to_i
end
