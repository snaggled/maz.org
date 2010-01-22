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

function build_checkin_map(container, checkins, settings) {
  if (checkins.length == 0) {
    container.hide();
    return;
  }

  // center the map on the most recent checkin
  var center = new google.maps.LatLng(checkins[0].venue.geolat,
    checkins[0].venue.geolong);

  var element = document.getElementById(container.attr("id"));
  var map = new google.maps.Map(element, {
    // overridden by bounding box
    zoom: 14, center: center,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  });

  var bounds = new google.maps.LatLngBounds();

  // add a marker for each checkin. process the checkins in
  // chronological order since the map will autopan to the final marker
  // opened (which we want to be the most recent checkin)
  for (var i=checkins.length-1; i>=0; i--) {
    var checkin = checkins[i];

    var latlng = new google.maps.LatLng(checkin.venue.geolat,
      checkin.venue.geolong);
    bounds.extend(latlng);

    var marker = new google.maps.Marker({map: map, position: latlng,
      title: checkin.venue.name});

    attach_info(checkin, marker);
  }

  map.fitBounds(bounds);
}

function attach_info(checkin, marker) {
  var info = new google.maps.InfoWindow({content: checkin_info(checkin)});

  google.maps.event.addListener(marker, 'click', function() {
    info.open(marker.getMap(), marker);
  });
}

function checkin_info(checkin) {
  return '<a target="_new" href="http://foursquare.com/venue/' +
    checkin.venue.fs_id + '">' + checkin.venue.name + '</a>' + "<br />" +
    checkin.venue.city + ", " + checkin.venue.state + "<br />" +
    Date.parse(checkin.checked_in_at).toString("h:m tt on MMM d");
}
