require 'factory_girl'

Factory.sequence :email_address do |n|
  "somebody#{n}@example.com"
end

Factory.define :user do |f|
  f.name                    'Jane Doe'
  f.login                   'jdoe'
  f.password                'doe_a_deer'
  f.password_confirmation   'doe_a_deer'
  f.email                   { Factory.next(:email_address) }
end

Factory.define :survey do |f|
  f.apple_1 "value for apple_1"
  f.apple_2 "value for apple_2"
  f.apple_3 "value for apple_3"
  f.apple_4 "value for apple_4"
  f.apple_5 "value for apple_5"
  f.health_check "4"
  f.famous_fives "value for famous_fives"
  f.age_range "value for age_range"
  f.country "value for country"
  f.name "value for name"
  f.email "value for email"
end
