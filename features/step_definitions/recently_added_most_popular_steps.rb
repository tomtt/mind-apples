Then /^I (should(?: not)?) see mindapples id for "([^\"]*)" at mindapple section$/ do |expectation, email|
  person = Person.find_by_email(email)
  mindapples_id = person.mindapples.first.id

  case expectation
  when "should"
    response.should have_xpath("//div[@class='most_recent']//li[@class='mindapple'][contains(.,'##{mindapples_id}')]")
  else
    response.should_not have_xpath("//div[@class='most_recent']//li[@class='mindapple'][contains(.,'##{mindapples_id}')]")
  end

end

Then /^I should see suggestion "([^\"]*)" for "([^\"]*)" at mindapple section$/ do |suggestion, email|
  response.should have_xpath("//div[@class='most_recent']//li[@class='mindapple'][contains(.,'#{suggestion}')]")
end

Then /^I should see name "([^\"]*)" for "([^\"]*)" at mindapple section$/ do |name, email|
  response.should have_xpath("//div[@class='most_recent']//li[@class='mindapple'][contains(.,'#{name}')]")
end

Then /^I (should(?: not)?) see the link with name "([^\"]*)" for "([^\"]*)" at mindapple section$/ do |expectation, link_text, email|
  case expectation
  when "should"
    response.should have_xpath("//div[@class='most_recent']//li[@class='mindapple']//a[text()='#{link_text}']")
  else
    response.should_not have_xpath("//div[@class='most_recent']//li[@class='mindapple']//a[text()='#{link_text}']")
  end
end
