class Tweet < Activity
  key :service_id, String, :required => true
  key :text, String, :required => true

  feed_url "http://twitter.com/statuses/user_timeline.atom?id=bcm&count=10"
  feed_since_param 'since_id'

private
  def self.create_from_atom(service_id, entry)
    text = entry.content.sanitize.gsub(/^bcm:\s*/, '')
    logger.debug("creating tweet #{service_id}")
    create!(:service_id => service_id, :text => text, :occurred_at => entry.published)
  end
end
