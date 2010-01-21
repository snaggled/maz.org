class FoursquareController < ApplicationController

  def checkins
    @checkins = MyFoursquare.new.history
    respond_to do |format|
      format.json {render :json => @checkins.to_json}
      format.html {render :layout => !request.xhr?}
    end
  end
end
