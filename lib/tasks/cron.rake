desc "Runs heroku's daily cron task - This is for the news feed"
task :cron => :environment do
  # It seems the time at which cron tasks are run on heroku is defined
  # by the time at which the heroku addon is added to the app - FAIL!
  # So we cannot set the time at which the cron runs without 
  # resetting when the cron add on was added
  BlogFeed.import_feeds
end