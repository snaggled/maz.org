class FoursquareController < ApplicationController

  def checkins
    @checkins = MyFoursquare.new.feed_checkins
    render :layout => !request.xhr?
  end
end
