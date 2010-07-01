# Custom build task for Cruise Control.
# See: http://vinsol.com/2007/08/30/customizing-cruisecontrol-build-for-rspec/
# Separate tasks for running rspec and cucumber tests exist to minimise cruise control execution time

desc 'Custom CruiseControl task for running all test suites'
task :cruise => ['cruise:spec', 'cruise:cucumber', 'cruise:jslint']

namespace :cruise do

  desc 'Custom CruiseControl task for running RSpec'
  task :spec => :initial_setup do
    # Invoke task to run RSpec
    CruiseControl::invoke_rake_task 'spec' 
  end

  desc 'Custom CruiseControl task for running Cucumber'
  task :cucumber => :initial_setup do
    # Invoke task to run non-WIP Cucumber features
    CruiseControl::invoke_rake_task 'cucumber'
  end

  desc 'Custom CruiseControl task for running JSlint'
  task :jslint => :initial_setup do
    # Invoke task to run jslint tests
    CruiseControl::invoke_rake_task 'jslint'
  end
  
  task :initial_setup do
    ENV['RAILS_ENV'] = 'test'  
    
    if File.exists?(Dir.pwd + "/config/database.yml")  
      if Dir[Dir.pwd + "/db/migrate/*.rb"].empty?  
        raise "No migration scripts found in db/migrate/ but database.yml exists, " +  
                "CruiseControl won't be able to build the latest test database. Build aborted."  
      end  
      
      # perform standard Rails database cleanup/preparation tasks if they are defined in project  
      # this is necessary because there is no up-to-date development database on a continuous integration box  
      if Rake.application.lookup('db:test:purge') and Rake.application.lookup('db:migrate')
        CruiseControl::invoke_rake_task 'db:test:purge' 
        
        CruiseControl::reconnect 
        CruiseControl::invoke_rake_task 'db:migrate' 
      end 
      
      # All that just to get an up to date schema.rb...
    end 
  end
end