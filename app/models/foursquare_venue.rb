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
    fs_id = v['id']

    fv = find_by_foursquare_id(fs_id)
    unless fv
      logger.debug("creating venue #{fs_id}")
      fv = FoursquareVenue.new(:foursquare_id => fs_id)
    end

    fill_venue(fv, v)
    fv.save!

    fv
  end

private
  def self.fill_venue(fv, v)
    fv.name = v['name']
    fv.address = v['address']
    fv.crossstreet = v['crossstreet']
    fv.city = v['city']
    fv.state = v['state']
    fv.zip = v['zip']
    fv.geolat = v['geolat']
    fv.geolong = v['geolong']
    fv.phone = v['phone']
  end
end
