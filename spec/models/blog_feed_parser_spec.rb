require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BlogFeedParser do

  before(:all) do
    xml_filename = File.join(Rails.root, 'spec', 'test_data', 'feed.xml')
    xml = File.read(xml_filename)
    FakeWeb.register_uri(:any, "http://mindapples.org/feed", :body => xml)

    parsed_data = BlogFeedParser.read('http://mindapples.org/feed')
    @data = parsed_data.first
  end

  it "reads the data from the FEED_URL" do
    parsed_data = BlogFeedParser.read('http://mindapples.org/feed')
    parsed_data.size.should == 10
  end

  describe "preparing data" do
    before(:all) do
      parsed_data = BlogFeedParser.read('http://mindapples.org/feed')
      @data = parsed_data.first
    end

    it "contains title" do
      @data[:title].should == 'The missing middle of modern meditation'
    end

    it "contains author" do
      pending
      @data[:author].should == '21awake'
    end

    it "contains content" do
      @data[:content].should include('This is the most common complaint that I hear from people who have either attended')
    end

    it "contains teaser" do
      @data[:teaser].should == "I have a lot of conversations about meditation.  And over the last few years, as the mainstream interest in meditation has grown and I’ve met more and more people wanting to learn the practice and the theory of meditation – and in particular mindfulness-based meditation –  the supply to satisfy the demand of that interest [...]<img src='http://stats.wordpress.com/b.gif?host=mindapples.org&blog=3742457&post=933&subd=mindapples&ref=&feed=1' border='0' alt=''/>"
    end

    it "contains published date" do
      @data[:published].should == "31 May 2010"
    end

    it "contains url" do
      @data[:url].should == 'http://mindapples.org/2010/05/31/the-missing-middle-of-modern-meditation/'
    end
  end

end
