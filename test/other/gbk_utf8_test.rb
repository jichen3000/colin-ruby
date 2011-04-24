require "kconv"
require "iconv"

#file_name = 'D:/work/test-workspace/henry-server/test.rb'
#file_name = 'D:/redmine-2008-5-27-1.txt'
#puts file_name
#to_file_name = ""
#file = File.open(file_name,"r")
#to_file = File.new(to_file_name,"w")
#k = Kconv.new
puts NKF::UTF8
puts NKF::ASCII
puts "中文".isutf8
#uiconv = Iconv.new( "utf-8","gbk")
uiconv = Iconv.new( "gbk","utf-8")
uiconv = Iconv.new( "gb2312","utf-8")
puts "中文"
puts uiconv.iconv("中文")
puts "123".isutf8
# iconv(to, from)
# 转换
giconv = Iconv.new("UTF-8//IGNORE", "UTF-8")
#giconv = Iconv.new("gbk", "UTF-8//IGNORE")
#giconv = Iconv.new("GBK//IGNORE", "UTF-8//IGNORE")
#uiconv = Iconv.new( "utf-8","gbk")
#while !file.eof?
#  line = file.readline
#  puts "guess: #{Kconv.guess(line)}"
#  puts line
#  ls = giconv.iconv(line)
##  ls = giconv.iconv(ls)
#  puts ls
#end

puts "ok"