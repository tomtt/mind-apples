require 'spork'

Spork.prefork do
  # Sets up the Rails environment for Cucumber
  ENV["RAILS_ENV"] ||= "cucumber"
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
  require 'cucumber/rails/world'

  # Comment out the next line if you don't want Cucumber Unicode support
  require 'cucumber/formatter/unicode'

  require 'webrat'
  require 'cucumber/webrat/table_locator' # Lets you do table.diff!(table_at('#my_table').to_a)

  Webrat.configure do |config|
    config.mode = :rails
    config.open_error_files = false # Set to true if you want error pages to pop up in the browser
  end

  require 'cucumber/rails/rspec'
  require 'webrat/core/matchers'

  require File.join(RAILS_ROOT, "spec", "shared_helper")

  require 'email_spec/cucumber'
end

Spork.each_run do
  require File.join(RAILS_ROOT, "spec", "factories")
end
