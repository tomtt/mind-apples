if %w(test cucumber).include?(Rails.env)
  OmniAuth.config.test_mode = true
end
