Then /^debugger$/ do
  debugger
end

Then "show me the page body in a rails context in a browser" do
  File.open(File.join(RAILS_ROOT, 'public', "tmp.html"),"w") do |f|
    f.puts response.body
  end
  system "open http://mindapples.local/tmp.html"
end

Then /^I should get a "(\d+) ([^"]+)" response$/ do |http_status, message|
debugger
  response.status.should == "#{http_status} #{message}"
end