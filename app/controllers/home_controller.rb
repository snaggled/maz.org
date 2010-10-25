class HomeController < ApplicationController

  def index
    @activities = Activity.activity_stream(15)
  rescue Mongo::ConnectionFailure => e
    logger.warn("Can't build activity stream: #{e.message}")
    @activities = []
  end
end
