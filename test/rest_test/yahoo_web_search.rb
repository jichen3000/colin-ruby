#!/usr/bin/ruby
# yahoo-web-search.rb
require 'open-uri'
require 'rexml/document'
require 'cgi'
BASE_URI = 'http://api.search.yahoo.com/WebSearchService/V1/webSearch'
def print_page_titles(term)
  # Fetch a resource: an XML document full of search results.
  term = CGI::escape(term)
  puts "term : #{term}"
  xml_file = open(BASE_URI + "?appid=restbook&query=#{term}")
  puts "xml_file : #{xml_file.class}"
  xml = xml_file.read
  save_file = File.open('save.xml','w+')
  save_file << xml
  save_file.close
  # Parse the XML document into a data structure.
  document = REXML::Document.new(xml)
  # Use XPath to find the interesting parts of the data structure.
  REXML::XPath.each(document, '/ResultSet/Result/Title/[]') do |title|
    puts title
  end
end
search_term = 'rest'
print_page_titles(search_term)
p "ok"