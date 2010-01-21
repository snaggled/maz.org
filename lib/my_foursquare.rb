class MyFoursquare

  def self.api
    Foursquare.new(AppConfig.foursquare.user,
      AppConfig.foursquare.password,
      :headers => {'User-Agent', 'maz.org'})
  end
end
