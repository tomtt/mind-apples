class BlogFeed < ActiveRecord::Base
  FEED_URL = "http://mindapples.org/feed/"

  validates_uniqueness_of :title
  validates_presence_of :teaser, :title, :url, :published

  def self.import_feeds
    feeds = BlogFeedParser.read(FEED_URL)
    feeds.each do |feed|
      BlogFeed.create(feed)
    end
  end
  
end