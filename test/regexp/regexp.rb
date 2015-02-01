str1 = 'ooo$asdfsa$sdsd'
str2 = "$$adfasd$sdfsd$sdfsdfd$"
reg = /.*(\$.+\$).*/

if str1 =~ reg
  puts $1,$'
end
if str2 =~ reg
  puts $1
end

require 'testhelper'

str1 = "sdf --More--"
str2 = "sdfds#"
str3 = "fsdfds"
reg = /--More--|#/

reg.match(str1).pt()
reg.match(str2).pt()
reg.match(str3).pt()

puts "ok"
