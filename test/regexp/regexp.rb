str1 = 'ooo$asdfsa$sdsd'
str2 = "$$adfasd$sdfsd$sdfsdfd$"
reg = /.*(\$.+\$).*/

if str1 =~ reg
  puts $1,$'
end
if str2 =~ reg
  puts $1
end
puts "ok"
