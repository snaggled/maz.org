module ApplicationHelper

  def activity_summary(activity)
    if activity.is_a?(FoursquareCheckin)
      svc = 'foursquare'
      summary = foursquare_checkin_summary(activity)
    elsif activity.is_a?(Tweet)
      svc = 'twitter'
      summary = tweet_summary(activity)
    elsif activity.is_a?(GoogleLink)
      svc = 'google'
      summary = google_link_summary(activity)
    end

    if summary
      icon = image_tag("icons/#{svc}.ico", :size => '16x16', :class => 'activity-icon')
      at = content_tag(:span, "at #{occurred_at(activity.occurred_at)}", :class => 'small')
      [icon, summary, at].join(' ')
    else
      ""
    end
  end

  def foursquare_checkin_summary(checkin)
    venue_link = link_to(h(checkin.venue.name), "http://foursquare.com/venue/#{checkin.venue.service_id}",
      :target => '_new', :class => 'foursquare-checkin-venue')

    venue_location = content_tag(:span, "#{h(checkin.venue.city)}, #{h(checkin.venue.state)}",
      :class => 'foursquare-checkin-location')

    out = "Checked in at #{venue_link} in #{venue_location}"
    out << " (#{checkin.shout})" if checkin.shout.present?

    out
  end

  def tweet_summary(tweet)
    "Tweeted \"#{tweet.text}\""
  end

  def google_link_summary(link)
    link_href = link_to(h(link.text), link.url, :target => '_new')

    out = "Shared #{link_href}"
    out << " by #{h(link.author)}" if link.author.present?

    out
  end

  def occurred_at(dt, options={})
    # 6:29 pm on Sat, Jan 23rd
    t = dt.strftime("%I:%M %p").gsub(/^0(\d)/, '\1').downcase
    d = dt.strftime("%a, %b #{dt.day.ordinalize}")
    content_tag(:span, "#{t} on #{d}", :class => 'occurred-at')
  end
end
