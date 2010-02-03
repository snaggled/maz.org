class HomeController < ApplicationController

  def index
    @activities = FoursquareCheckin.recent_checkins
  end
end
