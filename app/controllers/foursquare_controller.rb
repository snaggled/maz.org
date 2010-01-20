require 'Foursquare'

class FoursquareController < ApplicationController

  def index
    fq = Foursquare.new('bcm', 'hi')
    @checkins = fq.history
  rescue
    # FourSquare is brokie
  end
end
