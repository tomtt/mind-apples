Given /^I have a personal page$/ do
  @me_person = Factory.create(:person, :policy_checked => true)
end

Given /^my email is "(.*)"$/ do |email|
  @me_person.update_attributes!(:email => email)
end

Given /^my password is "([^\"]*)"$/ do |password|
  @me_person.user ||= Factory.build(:user)
  @me_person.update_attributes!(:user_attributes => {:password => password, :password_confirmation => password})
  @me_persons_password = password
end

Given /^my login is "([^\"]*)"$/ do |login|
  @me_person.user ||= Factory.build(:user)
  @me_person.update_attributes!(:user_attributes => {:login => login})
end

Given /^my braindump is "([^\"]*)"$/ do |braindump|
  @me_person.update_attributes!(:braindump => braindump)
end

Given /^my profile is private$/ do
  @me_person.update_attributes!(:public_profile => false)
end

Given /^my mindapple is "([^\"]*)"$/ do |mindapple|
  @me_person.mindapples.delete_all
  Factory.create(:mindapple, :suggestion => mindapple,  :person => @me_person)
end

Given /^my mindapples are:$/ do |mindapples|
  @me_person.mindapples.delete_all
  mindapples.rows.each do |mindapple|
    Factory.create(:mindapple, :suggestion => mindapple.first,  :person => @me_person)
  end
end

Given /^I am logged in$/ do
  @me_person ||= Factory.create(:person)
  Given 'my password is "drowssap"'
  visit login_path
  fill_in("Login", :with => @me_person.user.login)
  fill_in("password", :with => "drowssap")
  click_button("Log in")
end

Given /^I am not logged in$/ do
  visit logout_path
end

Given /^I am an admin$/ do
  user = Factory.create(:user, :role => 'admin')
  @me_person = Factory.create(:person, :user => user)
end

When /^I log in$/ do
  visit login_path
  fill_in("Login", :with => @me_person.user.login)
  fill_in("password", :with => @me_persons_password)
  click_button("Log in")
end

When /^I log out$/ do
  visit logout_path
end

Given /^I belong to the "([^\"]*)" network$/ do |name|
  @me_person.network = Network.find_by_name!(name)
  @me_person.save!
end
