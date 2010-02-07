module ApplicationHelper

  def activity_summary(activity)
    if activity.respond_to?(:foursquare_id)
      foursquare_checkin_summary(activity)
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

    # 6:29 pm on Sat, Jan 23rd
    ci_t = checkin.occurred_at.strftime("%I:%M %p").gsub(/^0(\d)/, '\1').downcase
    ci_d = checkin.occurred_at.strftime("%a, %b #{checkin.occurred_at.day.ordinalize}")
    checkin_time = content_tag(:span, "#{ci_t} on #{ci_d}", :class => 'foursquare-checkin-time')

    out = "#{icon} Checked in at #{venue_link} in #{venue_location} at #{checkin_time}"
    out << " (#{shout})" if checkin.shout.present?

    out
  end
end
