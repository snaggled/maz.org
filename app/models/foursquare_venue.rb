class FoursquareVenue < ActiveRecord::Base
  set_table_name 'fs_venues'
  has_many :checkins, :class_name => 'FoursquareCheckin',
    :foreign_key => 'fs_venue_id', :dependent => :nullify
end
