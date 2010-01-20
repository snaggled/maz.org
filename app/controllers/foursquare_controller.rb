require 'Foursquare'

class FoursquareController < ApplicationController

  def index
    fq = Foursquare.new('bcm', 'hi')
    @checkins = fq.history
  rescue Exception => e
    logger.error("Foursquare breakage: #{e.inspect}")
  end
end
