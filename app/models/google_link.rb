class GoogleLink < Activity
  key :google_id, String, :required => true
  key :text, String, :required => true
  key :url, String, :required => true

  activity_to_load :link

  # XXX: what about when I share with a message? how is that message represented?

  def self.load_links
    feed = fetch

    google_ids = feed.entries.map {|e| service_id(e.id)}
    idx = {}
    all(:google_id.in => google_ids).each do |link|
      idx[link.google_id] = link
    end

    feed.entries.each do |entry|
      google_id = service_id(entry.id)
      create_from_atom(google_id, entry) unless idx.has_key?(google_id)
    end
  end

private
  def self.fetch(options={})
    url = "http://www.google.com/reader/public/atom/user/17474520617057440479/state/com.google/broadcast"
    Feedzirra::Feed.fetch_and_parse(url, :user_agent => 'maz.org')
  end

  def self.service_id(entry_id)
    entry_id.split(/\//).last
  end

  def self.create_from_atom(google_id, entry)
    text = entry.title.sanitize.gsub(/^bcm:\s*/, '')
    url = entry.url
    logger.debug("creating link #{google_id}")
    create!(:google_id => google_id, :text => text, :url => url, :occurred_at => entry.published)
  end
end
