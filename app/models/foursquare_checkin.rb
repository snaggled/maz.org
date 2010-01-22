require 'my_foursquare'

class FoursquareCheckin < ActiveRecord::Base
  set_table_name 'fs_checkins'
  belongs_to :venue, :class_name => 'FoursquareVenue',
    :foreign_key => 'fs_venue_id'
  named_scope :ten_most_recent, :order => 'checked_in_at DESC', :limit => 10,
    :include => :venue

  def self.recent_checkins
    ten_most_recent.all
  end

  def self.load_checkins
    previous = ten_most_recent.first
    if previous.present?
      pull_in_recent_checkins_since(previous.fs_id)
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

    create!(:fs_id => fs_id, :shout => shout, :checked_in_at => checked_in_at,
      :venue => venue)
  end
end
