require "hpricot"
filename = File.join(File.dirname(__FILE__),"test.html")
doc = Hpricot(File.open(filename))
  
p doc