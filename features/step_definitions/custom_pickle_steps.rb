Given /^#{capture_model}\'s (.*) is "([^\"]*)"$/ do |model_ref, attribute, value|
  model = model!(model_ref)
  model.update_attributes!(attribute => value)
end
