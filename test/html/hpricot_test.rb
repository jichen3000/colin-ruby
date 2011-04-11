# load the Family guy's home page
require "rubygems"
require "hpricot" # need hpricot and open-uri
require "open-uri"
require "iconv"
doc = Hpricot(open("http://www.asahi.com/paper/column.html"))
#doc = Hpricot(open("D:/tmp/ruby/asahi.com.htm"))
# change the CSS class on list element ul
#(doc/"ul.site-nav").set("class", "new-site-nav")
# remove the header
#(doc/"#header").remove
# print the altered HTML

i = Iconv.open("utf-8", "EUC-JP")
#doc.search("p").each do |p|  
#doc.search("div[@id=HeadLine]").each do |p|  
#doc.search("div[@id=Nav]").each do |p|  
#doc.search('dl[@class="PrInfo"]').each do |p|  
#  p i.iconv(p.inner_html)  
#  p i.iconv(p.to_html)  
#end
#puts doc
#p i.iconv(doc.to_html)
doc.search("//div[@id=Main]").each do |item|
  p item.xpath
  p i.iconv(item.to_html)
  item.search("//div[@class=CateNav]").each do |p|
    p p.xpath
    puts "  "+i.iconv(p.to_html)
    p.search("//img").each do |p2|
      p p2.xpath
      p "    "+i.iconv(p2.to_html)
    end
  end
end 
#p doc
p "ok"