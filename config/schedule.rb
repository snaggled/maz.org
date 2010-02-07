every 15.minutes do
  runner "FoursquareCheckin.load_checkins"
  runner "Tweet.load_tweets"
end
