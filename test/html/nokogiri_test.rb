# load the Family guy's home page
require "rubygems"
require "nokogiri" # need hpricot and open-uri
require "open-uri"
require "iconv"
#doc = Nokogiri::HTML(open("http://www.asahi.com/paper/column.html"))
doc = Nokogiri::HTML(open("http://www.asahi.com/paper/column20100304.html"))
#doc = Hpricot(open("D:/tmp/ruby/asahi.com.htm"))
# change the CSS class on list element ul
#(doc/"ul.site-nav").set("class", "new-site-nav")
# remove the header
#(doc/"#header").remove
# print the altered HTML
out = open("d:/tmp/out.txt","a")

i = Iconv.open("utf-8", "EUC-JP")
p_arr = doc.css("p")
puts p_arr.size
out.puts
out.puts
out.puts i.iconv(p_arr[-4].inner_html)
out.puts i.iconv(p_arr[-2].inner_html)
#out.puts i.iconv(p_arr[0])
#doc.css("p").each do |item|
#  out.puts item.xpath
#  out.puts i.iconv(item.to_html)
#end 
#p doc
p "ok"