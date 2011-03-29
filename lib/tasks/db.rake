namespace :db do
  desc "Perform the tasks that need to run on heroku before going live from vps"
  task :go_live_from_vps_data => [:migrate, :seed, :import_avatars]

  desc "Assigns the users that have an avatar on the vps with the same one on heroku"
  task :import_avatars => :environment do
    Person.import_avatars_from_live_site
  end
end
