Given /^(\d+) people liked #{capture_model}$/ do |number_of_fans, name|
  mindapple = model(name)
  (1..number_of_fans.to_i).each do |i|
    person = Factory.create(:person, :email=> "#{rand}_test_#{i}@email.com")
    person.liked_mindapples << mindapple        
  end
end
