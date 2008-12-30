Given /I am on the login page/ do
  visit "/login"
end

Given /my username is "(.*)" and my password is "(.*)"/ do |username, password|
  @user = Factory.create(:user,
                         :login => username,
                         :password => password,
                         :password_confirmation => password)
end

Then /I should see a link to my profile/ do
  response.body.should have_xpath("//a[@href='#{user_path(@user)}']")
end
