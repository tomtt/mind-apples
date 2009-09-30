Given /^I have access to the inbox of "([^\"]*)"$/ do |email|
  mailbox_for(email)
end
