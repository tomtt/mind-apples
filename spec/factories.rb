# This file contains the factory definitions for factory_girl

require 'factory_girl'

Factory.define :person do |u|
  u.sequence(:email) {|n| "test#{n}@example.com" }
  u.sequence(:login) {|n| "user_#{n}" }
  u.password              "letmein"
  u.password_confirmation "letmein"
end
