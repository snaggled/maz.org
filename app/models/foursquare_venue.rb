class FoursquareVenue < ActiveRecord::Base
  set_table_name 'fs_venues'
  has_many :checkins, :class_name => 'FoursquareCheckin',
    :foreign_key => 'fs_venue_id', :dependent => :nullify

  def self.find_or_create_from_fs(v)
    fs_id = v['id'].to_i
    fv = find_or_create_by_fs_id(fs_id)
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
    fv
  end
end
