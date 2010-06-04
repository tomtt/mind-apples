Given /^I have a personal page$/ do
  When "I go to the \"take the test\" page"
  And "I check \"policy\""
  And "I press \"Submit\""
  And "I follow \"Log out\""
  @me_person = Person.last
end

Given /^my email is "(.*)"$/ do |email|
  @me_person.update_attributes(:email => email)
end

Given /^my password is "([^\"]*)"$/ do |password|
  @me_person.update_attributes(:password => password, :password_confirmation => password)
  @me_persons_password = password
end

Given /^my login is "([^\"]*)"$/ do |login|
  @me_person.login = login
  @me_person.save
end

Given /^my braindump is "([^\"]*)"$/ do |braindump|
  @me_person.update_attributes(:braindump => braindump)
end

Given /^I am logged in$/ do
  @me_person ||= Factory.create(:person)
  Given 'my password is "drowssap"'
  visit login_path
  fill_in("Login", :with => @me_person.login)
  fill_in("password", :with => "drowssap")
  click_button("Log in")
end

Given /^I am not logged in$/ do
  visit logout_path
end

When /^I log in$/ do
  visit login_path
  fill_in("Login", :with => @me_person.login)
  fill_in("password", :with => @me_persons_password)
  click_button("Log in")
end

When /^I log out$/ do
  visit logout_path
end
