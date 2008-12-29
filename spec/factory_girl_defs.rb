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
