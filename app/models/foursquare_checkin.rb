#require 'my_foursquare'

class FoursquareCheckin
  include MongoMapper::Document

  key :foursquare_id, String, :required => true
  key :shout, String
  key :checked_in_at, Time, :required => true

  timestamps!

  key :venue_id, ObjectId
  belongs_to :venue, :class_name => 'FoursquareVenue'

  def self.ten_most_recent
    all(:order => 'checked_in_at DESC', :limit => 10)
  end

  def self.recent_checkins
    idx = {}
    venue_ids = Set.new()

    ten_most_recent.each do |checkin|
      next unless checkin.venue_id.present?

      venue_ids << checkin.venue_id

      idx[checkin.venue_id] ||= []
      idx[checkin.venue_id] << checkin
    end

    checkins = {}
    FoursquareVenue.find(venue_ids.to_a).each do |venue|
      checkins[venue.foursquare_id] ||= {}
      checkins[venue.foursquare_id][:venue] = venue
      checkins[venue.foursquare_id][:checkins] ||= []
      checkins[venue.foursquare_id][:checkins] += idx[venue.id]
    end

    checkins
  end

  def self.load_checkins
    previous = first(:order => 'checked_in_at DESC')
    if previous.present?
      pull_in_recent_checkins_since(previous.foursquare_id)
    else
      pull_in_all_checkins
    end
  end

private
  def self.pull_in_all_checkins
    store_checkins(MyFoursquare.api.history)
  end

  def self.pull_in_recent_checkins_since(sinceid)
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
    fs_id = c['id'].to_i
    shout = c['shout']
    checked_in_at = DateTime::parse(c['created']) if c.has_key?('created')
    if c.has_key?('venue')
      venue = FoursquareVenue.find_or_create_from_fs(c['venue'])
    end

    checkin = create!(:foursquare_id => fs_id, :shout => shout,
      :checked_in_at => checked_in_at, :venue => venue)

    checkin
  end
end
