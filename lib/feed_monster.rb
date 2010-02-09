class FeedMonster
  def self.load_from_all_sources
    AppConfig.feed_monster.sources.each do |source|
      load_from_source(source)
    end
  end

  def self.load_from_named_source(name)
    found = false
    AppConfig.feed_monster.sources.each do |source|
      next unless source.name == name.to_s
      load_from_source(source)
      found = true
      break
    end
    raise "No source named #{name}" unless found
  end

private
  def self.load_from_source(source)
    klass = source.class_name.constantize
    if optional_config_entry(source, :feed).present?
      since_param = optional_config_entry(source.feed, :since_param)
      fetch_and_store_feed(klass, source.feed.url, :since_param => since_param)
    elsif optional_config_entry(source, :api).present?
      klass.send(source.api.method_name.to_sym)
    else
      raise "#{source.class_name} source has neither api nor feed config"
    end
  end

  def self.optional_config_entry(data, field)
    data.send(field.to_sym)
  rescue NoMethodError
    nil
  end

  def self.fetch_and_store_feed(klass, url, options={})
    if options[:since_param].present?
      previous = klass.most_recent_activity
      url << "?#{options[:since_param]}=#{previous.service_id}" if previous
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
    klazz.new(:service_id => service_id, :text => CGI::unescapeHTML(entry.title),
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