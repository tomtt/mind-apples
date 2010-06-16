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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BlogFeed do
  before(:each) do
    @valid_attributes = {
      :author => "Andy Gibsonr",
      :title => "Think like apple mind",
      :content => "When we are thinking like apple's mind than ...",
      :teaser => "This is description form the feed",
      :published => Date.today,
      :url => "link to original source"
    }
  end

  it "should create a new instance given valid attributes" do
    BlogFeed.create!(@valid_attributes)
  end

  it "has got url feed constant" do
     BlogFeed::FEED_URL.should == "http://mindapples.org/feed/"
  end

  describe "import_feeds" do
    it "import_feeds importing feeds into db" do
      xml_filename = File.join(Rails.root, 'spec', 'test_data', 'feed.xml')
      xml = File.read(xml_filename)
      FakeWeb.register_uri(:any, "http://mindapples.org/feed", :body => xml)

      BlogFeed.import_feeds
      BlogFeed.all.size.should == 10
    end

    it "import_feeds importing only valid feeds into db" do
      invalid_feed = {
        :author => "Andy Gibsonr",
        :title => "",
        :content => "When we are thinking like apple's mind than ...",
        :teaser => "This is description form the feed",
        :published => Date.today,
        :url => "link to original source"
      }
      
      feeds = [@valid_attributes, invalid_feed, @valid_attributes.merge(:title => 'new title')]
      BlogFeedParser.stubs(:read).returns(feeds)
      
      BlogFeed.import_feeds
      BlogFeed.all.size.should == 2
    end
  end
  
  it "validate uniqueness of the feed title" do
    BlogFeed.create(@valid_attributes.merge(:title => 'New very unique title'))
    Factory.build(:blog_feed, :title => 'New very unique title').should_not be_valid
  end

  it "validate uniqueness of the feed title" do
    BlogFeed.create(@valid_attributes.merge(:title => 'New very unique title'))
    Factory.build(:blog_feed, :title => 'Anothor very unique title').should be_valid
  end

  it "validate presence of the feed title" do
    Factory.build(:blog_feed, :title => '').should_not be_valid
  end
  
  it "validate teaser with blank content" do
    Factory.build(:blog_feed, :teaser => '').should_not be_valid
  end

  it "validate teaser with nil content" do
    Factory.build(:blog_feed, :teaser => nil).should_not be_valid
  end

  it "validate published presence" do
    Factory.build(:blog_feed, :published => nil).should_not be_valid
  end

  it "validate url presence" do
    Factory.build(:blog_feed, :url => '').should_not be_valid
  end
  
end