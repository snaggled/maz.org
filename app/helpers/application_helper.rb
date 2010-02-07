module ApplicationHelper

  def activity_summary(activity)
    if activity.respond_to?(:foursquare_id)
      foursquare_checkin_summary(activity)
    elsif activity.respond_to?(:twitter_id)
      tweet_summary(activity)
    else
      ""
    end
  end

  def foursquare_checkin_summary(checkin)
    icon = image_tag('icons/foursquare.ico', :size => '16x16', :class => 'activity-icon')

    venue_link = link_to(h(checkin.venue.name), "http://foursquare.com/venue/#{checkin.venue.foursquare_id}",
      :target => '_new', :class => 'foursquare-checkin-venue')

    venue_location = content_tag(:span, "#{h(checkin.venue.city)}, #{h(checkin.venue.state)}",
      :class => 'foursquare-checkin-location')

    at = occurred_at(checkin.occurred_at)

    out = "#{icon} Checked in at #{venue_link} in #{venue_location} at #{at}"
    out << " (#{checkin.shout})" if checkin.shout.present?

    out
  end

  def tweet_summary(tweet)
    icon = image_tag('icons/twitter.ico', :size => '16x16', :class => 'activity-icon')
    at = occurred_at(tweet.occurred_at)
    "#{icon} Tweeted \"#{tweet.text}\" at #{at}"
  end

  def occurred_at(dt, options={})
    # 6:29 pm on Sat, Jan 23rd
    t = dt.strftime("%I:%M %p").gsub(/^0(\d)/, '\1').downcase
    d = dt.strftime("%a, %b #{dt.day.ordinalize}")
    content_tag(:span, "#{t} on #{d}", :class => 'occurred-at')
  end
end
