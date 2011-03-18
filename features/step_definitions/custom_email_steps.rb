Given /^I have access to the inbox of "([^\"]*)"$/ do |email|
  mailbox_for(email)
end

When /^(?:I|they) click the link (?:containing|matching) "([^\"]*)" in the email$/ do |match|
  click_email_link_matching(Regexp.new(match))
end

When /^(?:I|they|"([^\"]*?)") opens? the most recent email$/ do |address|
  address = convert_address(address)
  email = mailbox_for(address).last
  if email.nil?
    raise Spec::Expectations::ExpectationNotMetError, "Could not find email.\n"
  end
  set_current_email(email)
end

Then /^in the email subject (?:I|they) should see "([^"]*?)"$/ do |text|
  current_email.should have_subject(text)
end
