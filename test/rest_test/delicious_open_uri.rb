#!/usr/bin/ruby -w
# delicious-open-uri.rb
require 'rubygems'
require 'rest-open-uri'
require 'rexml/document'
# Fetches a del.icio.us user's recent bookmarks, and prints each one.
def print_my_recent_bookmarks(username, password)
  # Make the HTTPS request.
  response = open('https://api.del.icio.us/v1/posts/recent',
  :http_basic_authentication => [username, password])
#  response = open('https://dingding3000:sc5964539@api.del.icio.us/v1/posts/recent')
  # Read the response entity-body as an XML document.
  xml = response.read
  save_file = File.open('save.xml','w+')
  save_file << xml
  save_file.close
end
username = 'dingding3000'
ps = 'sc5964539'
print_my_recent_bookmarks(username,ps)
p "ok"

