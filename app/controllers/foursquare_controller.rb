require 'Foursquare'

class FoursquareController < ApplicationController

  def index
    @checkins = foursquare.history
  rescue Exception => e
    logger.error("Foursquare breakage: #{e.inspect}")
  end

private
  def foursquare
    Foursquare.new(AppConfig.foursquare.user, AppConfig.foursquare.password,
      :headers => {'User-Agent', 'maz.org'})
  end
end
