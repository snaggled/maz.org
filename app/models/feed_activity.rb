class FeedActivity < Activity
  key :text, String, :required => true
  key :url, String
  key :author, String
end
