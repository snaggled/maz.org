require 'nokogiri'

class FeedActivity < Activity
  key :text, String, :required => true
  key :url, String
  key :author, String

  def self.create_from_atom(service_id, entry)
    author = entry.author if entry.author.present? && entry.author !~ /author unknown/i
    new(:service_id => service_id, :text => CGI::unescapeHTML(entry.title),
      :url => entry.url, :author => author, :occurred_at => entry.published)
  end

  def self.service_id(entry)
    entry.id.split(/\//).last
  end

  def self.parse_html(content)
    Nokogiri::HTML(content)
  end
end
