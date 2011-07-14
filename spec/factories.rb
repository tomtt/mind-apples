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

Factory.define :network do |n|
  n.sequence(:url) { |n| "network_#{n}" }
  n.sequence(:name) { |n| "network_#{n}" }
end

Factory.define :people_import do |i|
  i.s3_key "/path/from/factory"
  i.user_type_description "Factory description"
end

Factory.define :person do |u|
  u.sequence(:login) {|n| "user_#{n}" }
  u.sequence(:page_code) {|n| "%08d" % n }
  u.password              "letmein"
  u.password_confirmation "letmein"
  u.public_profile true
  u.policy_checked nil
  u.email {|n| "#{n}mind@apple.com" }
end

Factory.define :mindapple do |m|
  m.association :person, :factory => :person
end

Factory.define :authorization do |a|
  a.association :person, :factory => :person
  a.provider    "twitter"
  a.sequence(:uid) { |n| "#{n}12345678" }
end