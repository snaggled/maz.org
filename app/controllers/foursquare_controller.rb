class FoursquareController < ApplicationController

  def index
    @checkins = MyFoursquare.new.checkins
  end
end
