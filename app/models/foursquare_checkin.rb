#require 'my_foursquare'

class FoursquareCheckin
  include MongoMapper::Document

  attr_accessor :venue

  key :foursquare_id, String, :required => true
  key :shout, String
  key :checked_in_at, Time, :required => true
  key :venue_id, ObjectId

  timestamps!

  def self.most_recent
    all(:order => 'checked_in_at DESC', :limit => 25)
  end

  def self.first_most_recent
    first(:order => 'checked_in_at DESC')
  end

  def self.recent_checkins
    idx = {}
    venue_ids = Set.new()

    checkins = []
    most_recent.each do |checkin|
      next unless checkin.venue_id.present?
      venue_ids << checkin.venue_id

      checkins << checkin

      idx[checkin.venue_id] ||= []
      idx[checkin.venue_id] << checkins.length - 1
    end

    FoursquareVenue.find(venue_ids.to_a).each do |venue|
      idx[venue.id].each do |i|
        checkins[i].venue = venue
      end
    end

    checkins
  end

  def self.load_checkins
    previous = first_most_recent
    if previous.present?
      pull_in_recent_checkins_since(previous.foursquare_id)
    else
      pull_in_all_checkins
    end
  end

private
  def self.pull_in_all_checkins
    logger.debug("getting all checkins")
    store_checkins(MyFoursquare.api.history)
  end

  def self.pull_in_recent_checkins_since(sinceid)
    logger.debug("getting checkins since checkin #{sinceid}")
    store_checkins(MyFoursquare.api.history(:sinceid => sinceid))
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
    fs_id = c['id']
    shout = c['shout']
    checked_in_at = DateTime::parse(c['created']) if c.has_key?('created')
    if c.has_key?('venue')
      venue = FoursquareVenue.find_or_create_from_fs(c['venue'])
      venue_id = venue.id if venue
    end

    logger.debug("creating checkin #{fs_id}")
    checkin = create!(:foursquare_id => fs_id, :shout => shout,
      :checked_in_at => checked_in_at, :venue_id => venue_id)

    checkin
  end
end
