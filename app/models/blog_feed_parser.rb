require 'feed_tools'
class BlogFeedParser
  
  def self.read(url_of_feed_source)
    feed_source = FeedTools::Feed.open(url_of_feed_source)
    return self.parse_feed(feed_source)
  end
  
  private
  def self.parse_feed(feed_source)
    feeds = []

    feed_source.items.each do |feed|
      feeds << { :title => feed.title,
                 :author => feed.author.name,
                 :content => feed.content,
                 :teaser => feed.description,
                 :published => feed.published.strftime("%d %b %Y"),
                 :url => feed.link}
    end
    feeds
  end
end