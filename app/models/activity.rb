class Activity
  include MongoMapper::Document

  key :_type, String
  key :occurred_at, Time, :required => true

  timestamps!

  @@activities = {}

  def self.activity_to_load(sym)
    @@activities[self] = sym
  end

  def self.load_activities
    @@activities.each_pair do |klass, sym|
      meth = "load_#{sym.to_s.pluralize}".to_sym
      klass.send(meth)
    end
  end

  def self.most_recent_activity
    first(:order => 'occurred_at DESC')
  end

  def self.activity_stream
    all(:order => 'occurred_at DESC', :limit => 25)
  end
end
