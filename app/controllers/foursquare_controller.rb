class FoursquareController < ApplicationController

  def checkins
    @checkins = MyFoursquare.new.history
    render :layout => !request.xhr?
  end
end
