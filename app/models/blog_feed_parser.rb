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
                 :teaser => self.truncate(feed.description),
                 :published => feed.published.strftime("%d %b %Y"),
                 :url => feed.link}
    end
    feeds
  end

  def self.truncate(sentence)
    return if sentence.length <= 200
    sentence.split(//)[0..200].to_s + '...'
  end

end