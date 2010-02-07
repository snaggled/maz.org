class Activity
  include MongoMapper::Document

  key :_type, String
  key :service_id, String, :required => true
  key :occurred_at, Time, :required => true

  timestamps!

  @@activities = {}

  def self.activity_to_load(sym)
    @@activities[self] = "load_#{sym.to_s.pluralize}".to_sym
  end

  def self.load_all_activities
    @@activities.each_pair do |klass, val|
      load_activities(klass, val)
    end
  end

  def self.load_activities(klass, val=nil)
    val ||= @@activities[klass]
    if val.is_a?(Hash)
       klass.send(:fetch_and_store_feed, val[:url])
    elsif val.is_a?(Symbol)
       klass.send(val)
    else
       ArgumentError("Bad activity value #{val.inspect} for class #{klass.name}")
    end
  end

  def self.feed_url(url)
    @@activities[self] ||= {}
    @@activities[self][:url] = url
  end

  def self.feed_since(param)
    @@activities[self] ||= {}
    @@activities[self][:since] = param.to_s
  end

  def self.fetch_and_store_feed(url)
    if @@activities[self].has_key?(:since)
      previous = most_recent_activity
      url << "?#{@@activities[self][:since]}=#{previous.service_id}" if previous
    end

    logger.debug("Fetching feed at #{url}")
    feed = fetch_feed(url)

    service_ids = feed.entries.map {|e| service_id(e.id)}
    idx = {}
    all(:service_id.in => service_ids).each do |link|
      idx[link.service_id] = link
    end

    feed.entries.each do |entry|
      service_id = service_id(entry.id)
      create_from_atom(service_id, entry) unless idx.has_key?(service_id)
    end
  end

  def self.fetch_feed(url)
    # XXX: store and send etag and last-modified
    Feedzirra::Feed.fetch_and_parse(url, :user_agent => 'maz.org')
  end

  def self.service_id(entry_id)
    entry_id.split(/\//).last
  end

  def self.most_recent_activity
    first(:order => 'occurred_at DESC')
  end

  def self.activity_stream
    all(:order => 'occurred_at DESC', :limit => 25)
  end
end
