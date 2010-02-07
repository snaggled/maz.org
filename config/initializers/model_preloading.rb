# XXX: stupid hack to get around Rails loading models on demand in
# development mode

require 'mongo_mapper'

Tweet.new
FoursquareCheckin.new
GoogleLink.new
