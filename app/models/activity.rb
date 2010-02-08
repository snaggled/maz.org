class Activity
  include MongoMapper::Document

  key :_type, String
  key :service_id, String, :required => true
  key :occurred_at, Time, :required => true

  timestamps!

  def self.api_method(sym)
    FeedMonster.api_method(self, sym)
  end

  def self.feed_url(url)
    FeedMonster.feed_url(self, url)
  end

  def self.feed_since_param(param)
    FeedMonster.feed_since_param(self, param)
  end

  def self.most_recent_activity
    first(:order => 'occurred_at DESC')
  end

  def self.activity_stream
    all(:order => 'occurred_at DESC', :limit => 25)
  end
end
