Given /^I have a personal page$/ do
  @me_person = Factory.create(:person)
end

Given /^my email is "(.*)"$/ do |email|
  @me_person.update_attributes(:email => email)
end

Given /^my password is "([^\"]*)"$/ do |password|
  @me_person.update_attributes(:password => password, :password_confirmation => password)
end

Given /^my login is "([^\"]*)"$/ do |login|
  @me_person.update_attributes(:login => login)
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

When /^I log out$/ do
  visit logout_path
end
