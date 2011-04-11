require 'rjb'
Rjb.load
jString = Rjb::import('java.lang.String')
jstr = jString.new("12345")
puts jstr.toString
rstr = jstr.toString
p rstr
p rstr.class




p "ok"