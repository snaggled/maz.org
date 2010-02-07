class FoursquareVenue
  include MongoMapper::EmbeddedDocument

  key :service_id, String, :required => true
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
    fv = FoursquareVenue.new

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
