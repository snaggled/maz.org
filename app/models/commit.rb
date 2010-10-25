class Commit < FeedActivity

  def self.create_from_atom(service_id, entry)
    commit = super(service_id, entry)
    commit.text.gsub!(/\A#{entry.author} /, '')
    commit
  end
end
