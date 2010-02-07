class FoursquareCheckin < Activity
  key :shout, String
  key :venue_id, ObjectId
  key :venue, FoursquareVenue

  api_method :load_checkins

  def self.load_checkins
    previous = most_recent_activity
    if previous.present?
      pull_in_recent_checkins_since(previous.service_id)
    else
      pull_in_all_checkins
    end
  end

private
  def self.history(options={})
    client = Foursquare.new(AppConfig.foursquare.user,
      AppConfig.foursquare.password, :headers => {'User-Agent', 'maz.org'})
    client.history(options)
  end

  def self.pull_in_all_checkins
    logger.debug("getting all checkins")
    store_checkins(history)
  end

  def self.pull_in_recent_checkins_since(sinceid)
    logger.debug("getting checkins since checkin #{sinceid}")
    store_checkins(history(:sinceid => sinceid))
  end

  def self.store_checkins(api_response)
    return if ! api_response.has_key?('checkins') ||
      api_response['checkins'].nil?

    api_checkins = api_response['checkins']['checkin']
    api_checkins = [api_checkins] unless api_checkins.is_a?(Array)

    api_checkins.each do |c|
      create_from_fs(c)
    end
  end

  def self.create_from_fs(c)
    service_id = c['id']
    shout = c['shout']
    checked_in_at = DateTime::parse(c['created']) if c.has_key?('created')
    venue = FoursquareVenue.new_from_fs(c['venue']) if c.has_key?('venue')
    logger.debug("creating checkin #{service_id}")
    create!(:service_id => service_id, :shout => shout, :occurred_at => checked_in_at, :venue => venue)
  end
end
