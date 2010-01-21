class FoursquareController < ApplicationController

  def checkins
    @checkins = MyFoursquare.new.checkins
    render :layout => !request.xhr?
  end
end
