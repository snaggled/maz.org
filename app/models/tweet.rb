class Tweet < Activity
  key :twitter_id, String, :required => true
  key :text, String, :required => true

  activity_to_load :tweet

  def self.load_tweets
    previous = most_recent_activity
    if previous.present?
      pull_in_recent_tweets_since(previous.twitter_id)
    else
      pull_in_all_tweets
    end
  end

private
  def self.timeline(options={})
    url = "http://twitter.com/statuses/user_timeline.atom?id=bcm&count=10"
    url << "&since_id=#{options[:sinceid]}" if options.has_key?(:sinceid)
    Feedzirra::Feed.fetch_and_parse(url)
  end

  def self.pull_in_all_tweets
    logger.debug("getting all tweets")
    store_tweets(timeline)
  end

  def self.pull_in_recent_tweets_since(sinceid)
    logger.debug("getting tweets since tweet #{sinceid}")
    store_tweets(timeline(:sinceid => sinceid))
  end

  def self.store_tweets(feed)
    feed.entries.each do |entry|
      create_from_atom(entry)
    end
  end

  def self.create_from_atom(entry)
    entry.id =~ /\/(\d+)$/
    twitter_id = $1

    text = entry.content.sanitize.gsub(/^bcm:\s*/, '')

    logger.debug("creating tweet #{twitter_id}")
    tweet = new(:twitter_id => twitter_id, :text => text, :occurred_at => entry.published)

    tweet.save!

    tweet
  end
end
