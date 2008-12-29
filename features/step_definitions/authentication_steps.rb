Given /I am on the login page/ do
  visit "/login"
end

Given /my username is "(.*)" and my password is "(.*)"/ do |username, password|
  @user = Factory.create(:user,
                         :login => username,
                         :password => password,
                         :password_confirmation => password)
end
