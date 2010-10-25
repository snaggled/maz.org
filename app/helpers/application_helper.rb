module ApplicationHelper

  def activity_summary(activity, &block)
    fmt = :ico
    if activity.is_a?(Checkin)
      svc = 'foursquare'
      summary = checkin_summary(activity)
    elsif activity.is_a?(Tweet)
      svc = 'twitter'
      summary = tweet_summary(activity)
    elsif activity.is_a?(Link)
      svc = 'google'
      summary = link_summary(activity)
    elsif activity.is_a?(Bookmark)
      svc = 'delicious'
      summary = bookmark_summary(activity)
    elsif activity.is_a?(Tumblog)
      svc = 'tumblr'
      fmt = :gif
      summary = tumblog_summary(activity)
    elsif activity.is_a?(Video)
      svc = 'youtube'
      summary = video_summary(activity)
    elsif activity.is_a?(Photo)
      svc = 'flickr'
      summary = photo_summary(activity)
    end

    yield(svc, fmt, summary) if summary

    ''
  end

  def icon_tag(svc, fmt = :ico, options = {})
    image_tag("icons/#{svc}.#{fmt}", {:size => '16x16', :class => 'activity-icon'}.merge(options))
  end

  def checkin_summary(checkin)
    venue_link = link_to(h(checkin.venue.name), "http://foursquare.com/venue/#{checkin.venue.service_id}",
      :target => '_new', :class => 'foursquare-checkin-venue')

    venue_location = content_tag(:span, "#{h(checkin.venue.city)}, #{h(checkin.venue.state)}",
      :class => 'foursquare-checkin-location')

    out = "Checked in at #{venue_link} in #{venue_location}"
    out << " with \"#{checkin.shout}\"" if checkin.shout.present?

    out.html_safe
  end

  def tweet_summary(tweet)
    "Tweeted \"#{tweet.text}\""
  end

  def link_summary(link)
    link_href = link_to(h(link.text), link.url, :target => '_new')

    out = "Shared #{link_href}"
    out << " by #{h(link.author)}" if link.author.present?

    out.html_safe
  end

  def bookmark_summary(bookmark)
    href = link_to(h(bookmark.text), bookmark.url, :target => '_new')
    "Bookmarked #{href}".html_safe
  end

  def tumblog_summary(tumblog)
    href = link_to(h(tumblog.text), tumblog.url, :target => '_new')
    "Wrote #{href}".html_safe
  end

  def video_summary(video)
    href = link_to(h(video.text), video.url, :target => '_new')
    "Favorited #{href}".html_safe
  end

  def photo_summary(photo)
    if photo.text.present?
      caption = photo.text
    else
      caption = "uncaptioned photo"
    end
    href = link_to(caption, photo.url, :target => '_new')
    "Uploaded #{href}".html_safe
  end

  def occurred_at(dt, options={})
    # 6:29 pm on Sat, Jan 23rd
    t = dt.strftime("%I:%M %p").gsub(/^0(\d)/, '\1').downcase
    d = dt.strftime("%a, %b #{dt.day.ordinalize}")
    content_tag(:span, "#{t} on #{d}", :class => 'occurred-at').html_safe
  end
end
