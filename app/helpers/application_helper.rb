module ApplicationHelper

  def activity_summary(activity)
    foursquare_checkin_summary(activity)
  end

  def foursquare_checkin_summary(checkin)
    venue_link = link_to(h(checkin.venue.name),
      "http://foursquare.com/venue/#{checkin.venue.foursquare_id}",
      :target => '_new', :class => 'foursquare-checkin-venue')

    venue_location = content_tag(:span,
      "#{h(checkin.venue.city)}, #{h(checkin.venue.state)}",
      :class => 'foursquare-checkin-location')

    # 6:29 pm on Sat, Jan 23rd
    ci_t = checkin.checked_in_at.strftime("%I:%M %p").
      gsub(/^0(\d)/, '\1').downcase
    ci_d = checkin.checked_in_at.
      strftime("%a, %b #{checkin.checked_in_at.day.ordinalize}")
    checkin_time = content_tag(:span, "#{ci_t} on #{ci_d}",
      :class => 'foursquare-checkin-time')

    "Checked in at #{venue_link} in #{venue_location} at #{checkin_time}"
  end
end
