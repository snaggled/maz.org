class FoursquareVenue
  include MongoMapper::Document

  key :foursquare_id, String, :required => true
  key :name, String
  key :address, String
  key :crossstreet, String
  key :city, String
  key :state, String
  key :zip, String
  key :geolat, Float
  key :geolong, Float
  key :phone, String

  timestamps!

  many :checkins, :class_name => 'FoursquareCheckin', :dependent => :nullify

  def self.find_or_create_from_fs(v)
    fs_id = v['id'].to_i
    fv = find_or_create_by_foursquare_id(fs_id)
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
