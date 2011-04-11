require "hpricot"
filename = File.join(File.dirname(__FILE__),"EXP.htm")
doc = Hpricot(File.open(filename))
doc.search("//div[@class=msgentry]").each do |item|
#  p item.xpath
#  p item.to_html
#  p item.class
  item.search("//span[@class=msg]").each do |item2|
    p item2.xpath
    p item2.inner_text
#    p item2.class
#    p item2.to_html
  end
end

p "ok"
