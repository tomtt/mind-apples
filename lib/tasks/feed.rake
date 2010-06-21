namespace :feed do
  desc "Import feeds from mindapples blog"
  task :import => :environment do
    BlogFeed.import_feeds
  end
end