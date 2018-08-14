require 'nokogiri'
cur_page = File.open("evan_http_10g_21k_1_test.html") { |f| Nokogiri::HTML(f) }

# same as mechanize