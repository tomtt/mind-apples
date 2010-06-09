When /^(?:|I )try to go to (.+)$/ do |page_name|
  begin
    old_rescue_value = ActionController::Base.allow_rescue
    ActionController::Base.allow_rescue = true
    # Make Rails treat the request as an external request so we get the public error handing
    header "REMOTE-ADDR", "10.0.1.1"
    When "I go to #{page_name}"
  rescue Exception
    # Swallow 500 errors and the like because that's what we need to test.
  ensure
    ActionController::Base.allow_rescue = old_rescue_value
  end
end