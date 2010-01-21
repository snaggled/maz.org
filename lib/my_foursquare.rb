class MyFoursquare

  def initialize
    @fs = Foursquare.new(AppConfig.foursquare.user,
      AppConfig.foursquare.password,
      :headers => {'User-Agent', 'maz.org'})
  end

  def checkins
    fc = @fs.friend_checkins['checkins']['checkin']
    fc.map do |c|
      out = {}
      out[:venue] = c['venue']['name'] if c.has_key?('venue')
      out[:shout] = c['shout'] if c.has_key?('venue')
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
