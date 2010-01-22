jQuery.fn.checkin_map = function(options) {
  var settings = {
    url: null,
  };
  if (options) {
    $.extend(settings, options);
  }

  var container = this;

  $.getJSON(settings.url, function(checkins) {
    build_checkin_map(container, checkins, settings);
  });

  return this;
}

function build_checkin_map(container, data, settings) {
  if (data.length == 0) {
    container.hide();
    return;
  }

  // center the map on my house
  var center = new google.maps.LatLng(40.718634, -73.956866);

  var element = document.getElementById(container.attr("id"));
  var map = new google.maps.Map(element, {
    // overridden by bounding box
    zoom: 14, center: center,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  var bounds = new google.maps.LatLngBounds();

  // add a marker for each venue
  for (var venue_id in data) {
    var venue = data[venue_id].venue
    var checkins = data[venue_id].checkins

    var latlng = new google.maps.LatLng(venue.geolat, venue.geolong);
    bounds.extend(latlng);

    var marker = new google.maps.Marker({map: map, position: latlng,
      title: venue.name});

    attach_info_window(marker, venue, checkins);
  }

  map.fitBounds(bounds);
}

function attach_info_window(marker, venue, checkins) {
  var info = new google.maps.InfoWindow({
    content: venue_info(venue, checkins)
  });

  google.maps.event.addListener(marker, 'click', function() {
    info.open(marker.getMap(), marker);
  });
}

function venue_info(venue, checkins) {
  str = '<p><a target="_new" href="http://foursquare.com/venue/' +
    venue.foursquare_id + '">' + venue.name + '</a><br/>' + venue.city +
    ', ' + venue.state + '</p>'
  str += '<ol>'
  for (var i=0; i<checkins.length; i++) {
    var checkin = checkins[i];
    str += '<li>' +
      Date.parse(checkin.checked_in_at).toString("h:m tt on MMM d") + '</li>'
  }
  str += '</ol>'
  return str;
}
