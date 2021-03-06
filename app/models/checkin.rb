class CheckinVenue
  include MongoMapper::EmbeddedDocument

  key :service_id, String
  key :name, String
  key :address, String
  key :crossstreet, String
  key :city, String
  key :state, String
  key :zip, String
  key :geolat, Float
  key :geolong, Float
  key :phone, String

  def self.new_from_fs(v)
    fv = new

    fv.service_id = v['id']
    fv.name = v['name']
    fv.address = v['address']
    fv.crossstreet = v['crossstreet']
    fv.city = v['city']
    fv.state = v['state']
    fv.zip = v['zip']
    fv.geolat = v['geolat']
    fv.geolong = v['geolong']
    fv.phone = v['phone']

    fv
  end
end

class Checkin < Activity
  key :shout, String
  key :venue_id, ObjectId
  key :venue, CheckinVenue

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
    oauth = Foursquare::OAuth.new(AppConfig.foursquare.oauth_key, AppConfig.foursquare.oauth_secret)
    oauth.authorize_from_access(AppConfig.foursquare.access_token, AppConfig.foursquare.access_secret)
    foursquare = Foursquare::Base.new(oauth)
    foursquare.history(options)
  end

  def self.pull_in_all_checkins
    logger.debug("getting all checkins")
    store_checkins(history)
  end

  def self.pull_in_recent_checkins_since(sinceid)
    logger.debug("getting checkins since checkin #{sinceid}")
    store_checkins(history(:sinceid => sinceid))
  end

  def self.store_checkins(checkins)
    checkins.each do |c|
      create_from_fs(c)
    end
  end

  def self.create_from_fs(c)
    service_id = c['id']
    shout = c['shout']
    checked_in_at = DateTime::parse(c['created']) if c.has_key?('created')
    venue = CheckinVenue.new_from_fs(c['venue']) if c.has_key?('venue')
    logger.debug("creating checkin #{service_id}")
    create!(:service_id => service_id, :shout => shout, :occurred_at => checked_in_at, :venue => venue)
  end
end
