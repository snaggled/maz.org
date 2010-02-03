class FoursquareController < ApplicationController

  def checkins
    @checkins = FoursquareCheckin.recent_checkins
    respond_to do |format|
      format.json do
        render :json => @checkins.to_json
      end
    end
  end
end
