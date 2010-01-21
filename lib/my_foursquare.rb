require 'rss'
require 'open-uri'

class MyFoursquare

  def initialize
    @fs = Foursquare.new(AppConfig.foursquare.user,
      AppConfig.foursquare.password,
      :headers => {'User-Agent', 'maz.org'})
  end

  def feed_checkins
    url = 'http://feeds.foursquare.com/history/2a5ca48c03859a8abbf2cc358411893c.rss?count=8'

    open(url) do |f|
      rss = RSS::Parser.parse(f.read, false)
      rss.items.map do |item|
        out = {}
        out[:venue] = item.title
        out[:when] = item.pubDate
        out
      end
    end
  end

  def api_checkins
    fc = @fs.friend_checkins['checkins']['checkin']
    fc.map do |c|
      out = {}
      out[:venue] = c['venue']['name'] if c.has_key?('venue')
      out[:shout] = c['shout'] if c.has_key?('shout')
      if c.has_key?('created')
        out[:when] = DateTime::parse(c['created']).in_time_zone
      end
      out
    end
  rescue REXML::ParseException => e
    RAILS_DEFAULT_LOGGER.debug("Foursquare API request unsuccessful: " +
      e.inspect)
    nil
  end
end
