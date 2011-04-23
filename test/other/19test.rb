#length = 1000
#length.times do |i|
##  puts 10**i
#  puts i if ((10 ** i-2) % 19) == 0
#end
#len = 53
#xpy =  ((10 ** len - 2) / 19)
#2.upto(9) do |y|
#  x = y * xpy
#  puts "y : #{y}"
#  puts "x : #{x}"
#  puts "x.size : #{x.to_s.length}"
#  z1 = x*10+y
#  z2 = y*(10**(x.to_s.length))+x
#  puts "z1 : #{z1}"
#  puts "z2 : #{z2}"
#  puts "2*z1 : #{2*z1}"
#  
#end
#puts "ok"

a = [12345].pack('L')
b = [56789].pack('L')
p a[0,2]
p b[0]
p (a[0,2]|b[0,2])