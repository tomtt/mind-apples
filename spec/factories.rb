# This file contains the factory definitions for factory_girl

require 'factory_girl'

Factory.define :user do |u|
  u.sequence(:email) {|n| "test#{n}@example.com" }
  u.password              "letmein"
  u.password_confirmation "letmein"
end
