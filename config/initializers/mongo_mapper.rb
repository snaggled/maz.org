require 'mongo_mapper'

host = AppConfig.mongo.host
port = AppConfig.mongo.port

begin
  MongoMapper.database = 'maz'
  MongoMapper.connection = Mongo::Connection.new(host, port, :logger => Rails.logger)
  Rails.logger.info("Connected to mongo on #{host}:#{port}")
rescue Mongo::ConnectionFailure => e
  Rails.logger.warn("Unable to connect to mongo on #{host}:#{port}")
end
