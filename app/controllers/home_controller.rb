class HomeController < ApplicationController
  caches_action :index, :expires_in => 15.minutes

  def index
    @activities = Activity.activity_stream(15)
  rescue Mongo::ConnectionFailure => e
    logger.warn("Can't build activity stream: #{e.message}")
    @activities = []
  end
end
