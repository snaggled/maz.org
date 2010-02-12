class Activity
  include MongoMapper::Document

  key :_type, String
  key :service_id, String, :required => true
  key :occurred_at, Time, :required => true

  timestamps!

  def self.most_recent_activity
    first(:order => 'occurred_at DESC')
  end

  def self.activity_stream(limit=25)
    all(:order => 'occurred_at DESC', :limit => limit)
  end
end
