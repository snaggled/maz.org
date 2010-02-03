class Activity
  include MongoMapper::Document

  key :_type, String
  key :occurred_at, Time, :required => true

  timestamps!

  def self.most_recent_activity
    first(:order => 'occurred_at DESC')
  end

  def self.activity_stream
    all(:order => 'occurred_at DESC', :limit => 25)
  end
end
