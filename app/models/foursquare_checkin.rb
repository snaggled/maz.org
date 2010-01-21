require 'my_foursquare'

class FoursquareCheckin < ActiveRecord::Base
  set_table_name 'fs_checkins'
  belongs_to :venue, :class_name => 'FoursquareVenue',
    :foreign_key => 'fs_venue_id'
  named_scope :ten_most_recent, :order => 'checked_in_at DESC', :limit => 10,
    :include => :venue

  def self.recent_checkins
    # XXX: move the caching into an external tool so that we can literally
    # just call ten_most_recent
    previous = ten_most_recent
    if previous.empty?
      pull_in_all_checkins
    else
      pull_in_recent_checkins_since(previous.first.fs_id)
    end
    ten_most_recent.all
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

    api_response['checkins']['checkin'].each do |c|
      fs_checkin_id = c['id'].to_i
      shout = c['shout']
      checked_in_at = DateTime::parse(c['created']) if c.has_key?('created')
      if c.has_key?('venue')
        v = c['venue']
        fs_venue_id = v['id'].to_i
        fv = FoursquareVenue.find_or_create_by_fs_id(fs_venue_id)
        fv.name = v['name']
        fv.address = v['address']
        fv.crossstreet = v['crossstreet']
        fv.city = v['city']
        fv.state = v['state']
        fv.zip = v['zip']
        fv.geolat = v['geolat']
        fv.geolong = v['geolong']
        fv.phone = v['phone']
        fv.save!
      end

      FoursquareCheckin.create!(:fs_id => fs_checkin_id, :shout => shout,
        :checked_in_at => checked_in_at, :venue => fv)
    end
  end
end
