class Video < Activity
  before_save :tweak_occurred_at

  # YouTube reports publication date as when the video was uploaded, not
  # when the user favorited it, so set occurred_at if the video was published
  # before today (presumes the user isn't favoriting a video uploaded today)
  def tweak_occurred_at
    self.occurred_at = created_at if occurred_at.to_date < Date.yesterday
  end
end
