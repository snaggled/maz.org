class FeedMonster
  @@sources = {}

  def self.api_method(klass, sym)
    @@sources[klass] ||= {}
    @@sources[klass][:api_method] = sym
  end

  def self.feed_url(klass, url)
    @@sources[klass] ||= {}
    @@sources[klass][:feed_url] = url
  end

  def self.feed_since_param(klass, param)
    @@sources[klass] ||= {}
    @@sources[klass][:feed_since_param] = param.to_s
  end

  def self.load_from_all_sources
    @@sources.each_pair do |klass, val|
      load_from_source(klass, val)
    end
  end

  def self.load_from_source(klass, val=nil)
    val ||= @@sources[klass]
    if val.has_key?(:api_method)
      klass.send(val[:api_method])
    elsif val.has_key?(:feed_url)
      fetch_and_store_feed(klass, val[:feed_url], :since_param => val[:feed_since_param])
    else
       ArgumentError("bad source value #{val.inspect} for class #{klass.name}")
    end
  end

  def self.fetch_and_store_feed(klass, url, options={})
    if options.has_key?(:feed_since_param)
      previous = klass.most_recent_activity
      url << "?#{options[:feed_since_param]}=#{previous.service_id}" if previous
    end

    Rails.logger.debug("fetching feed at #{url}")
    feed = fetch_feed(url)

    service_ids = feed.entries.map {|e| service_id(e.id)}
    idx = {}
    klass.all(:service_id.in => service_ids).each do |link|
      idx[link.service_id] = link
    end

    feed.entries.each do |entry|
      service_id = service_id(entry.id)
      # XXX: update
      unless idx.has_key?(service_id)
        activity = new_from_atom(klass, service_id, entry)
        Rails.logger.debug("creating activity #{activity.service_id}")
        activity.save!
      end
    end
  end

  def self.new_from_atom(klazz, service_id, entry)
    author = entry.author if entry.author.present? && entry.author !~ /author unknown/i
    klazz.new(:service_id => service_id, :text => entry.title,
      :url => entry.url, :author => author, :occurred_at => entry.published)
  end

  def self.fetch_feed(url)
    # XXX: store and send etag and last-modified
    Feedzirra::Feed.fetch_and_parse(url, :user_agent => 'maz.org')
  end

  def self.service_id(entry_id)
    entry_id.split(/\//).last
  end
end