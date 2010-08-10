When /^the person "([^\"]*)" is sent instructions on how to claim h(?:er|is) page$/ do |pickle_ref|
  person = model!("the person \"#{pickle_ref}\"")
  person.deliver_claim_your_page_instructions!
end
