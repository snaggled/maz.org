class Tweet < FeedActivity
  before_save :trim_text

  def trim_text
    self.text = text.gsub(/^bcm:\s*/, '')
  end
end
