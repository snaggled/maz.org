class GoogleLink < Activity
  key :text, String, :required => true
  key :url, String, :required => true

  feed_url "http://www.google.com/reader/public/atom/user/17474520617057440479/state/com.google/broadcast"

  # XXX: what about when I share with a message? how is that message represented?

private
  def self.create_from_atom(service_id, entry)
    text = entry.title.sanitize
    logger.debug("creating link #{service_id}")
    create!(:service_id => service_id, :text => text, :url => entry.url, :occurred_at => entry.published)
  end
end
