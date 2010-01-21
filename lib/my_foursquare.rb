class MyFoursquare

  def initialize
    @fs = Foursquare.new(AppConfig.foursquare.user,
      AppConfig.foursquare.password,
      :headers => {'User-Agent', 'maz.org'})
  end

  def checkins
    @fs.history['checkins'].map do |checkin|
      {
        :venue => checkin.venue.name,
        :shout => checkin.shout,
        :when => checkin.created,
      }
    end
  rescue Exception => e
    RAILS_DEFAULT_LOGGER.error("Foursquare breakage: #{e.inspect}")
    nil
  end
end
