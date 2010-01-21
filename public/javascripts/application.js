jQuery.fn.checkin_map = function(options) {
  var settings = {
    url: null,
  };
  if (options) {
    $.extend(settings, options);
  }

  var block = this;

  $.getJSON(settings.url, function(checkins) {
    str = "<ol>";
    for (var i=0; i<checkins.length; i++) {
      var checkin = checkins[i];
      str += "<li>";
      str += checkin.venue.name;
      str += " at ";
      str += Date.parse(checkin.checked_in_at).toString("h:m tt on MMM d");
      str += "</li>";
    }
    str += "</ol>";
    block.html(str);
  });

  return this;
}
