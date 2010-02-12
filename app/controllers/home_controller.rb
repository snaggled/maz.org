class HomeController < ApplicationController

  def index
    @activities = Activity.activity_stream(30)
  end
end
