class HomeController < ApplicationController

  def index
    @activities = Activity.activity_stream
  end
end
