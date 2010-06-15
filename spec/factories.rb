# This file contains the factory definitions for factory_girl

require 'factory_girl'

Factory.define :blog_feed do |u|
  u.author "Andy Gibsonr"
  u.title "Think like apple mind"
  u.content "When we are thinking like apple's mind than ..."
  u.teaser "This is description form the feed"
  u.published Date.today
  u.url "link to original source"
end

Factory.define :person do |u|
  u.sequence(:login) {|n| "user_#{n}" }
  u.sequence(:page_code) {|n| "%08d" % n }
  u.password              "letmein"
  u.password_confirmation "letmein"
  u.public_profile true
  u.policy_checked true
  u.email 'mind@apple.com'
end


Factory.define :mindapple do |m|
end
