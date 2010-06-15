class CreateBlogFeeds < ActiveRecord::Migration
  def self.up
    create_table :blog_feeds do |t|
      t.string :author
      t.string :title
      t.text :content
      t.string :teaser
      t.date :published
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :blog_feeds
  end
end
