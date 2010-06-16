# == Schema Information
#
# Table name: blog_feeds
#
#  id         :integer(4)      not null, primary key
#  author     :string(255)
#  title      :string(255)
#  content    :text
#  teaser     :string(255)
#  published  :date
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

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
