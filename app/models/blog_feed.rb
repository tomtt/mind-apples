# == Schema Information
#
# Table name: blog_feeds
#
#  id         :integer         not null, primary key
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
  FEED_URL = "http://blog.mindapples.org/feed/"

  validates_uniqueness_of :title
  validates_presence_of :teaser, :title, :url, :published

  def self.import_feeds
    feeds = BlogFeedParser.read(FEED_URL)
    feeds.each do |feed|
      BlogFeed.create(feed)
    end
  end

  def self.latest(count)
    BlogFeed.find(:all, :limit => count, :order => 'published DESC')
  end

end
