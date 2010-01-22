require 'mongo_mapper'

MongoMapper.database = 'maz'
MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017,
  :logger => Rails.logger)
