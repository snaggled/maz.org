class Tweet < Activity
  feed_url "http://twitter.com/statuses/user_timeline.atom?id=bcm&count=10"
  feed_since_param 'since_id'
  before_save :trim_text

  def trim_text
    self.text = text.gsub(/^bcm:\s*/, '')
  end
end
