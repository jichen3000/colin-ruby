# 测试二进制写和文本方式写入的速度差异
# count: 1000W
#user     system      total        real
#bin  6.719000   0.406000   7.125000 (  9.375000)
#str  9.234000   0.500000   9.734000 (  9.969000)

#STRING = 'abcdefg 1234567890 hijklmn '*3
STR = "abcdefg 12 hijk\n"
def puts_file(file_name)
  file = File.new(file_name,'r')
  lines = file.readlines
  lines.each do |item|
    puts item
  end
end
def save2bin(filename,count)
  file = File.new(filename,'wb')
  count.times do |index|
    file.write(STR)
  end
  file.close
end
def save2str(filename,count)
  file = File.new(filename,'w')
  count.times do |index|
    file  << STR
  end
  file.close
end
bin_file_name = 'd:/tmp/log/bin'
str_file_name = 'd:/tmp/log/str'
count = 1000_0000
#save2bin(bin_file_name,count)
#save2str(str_file_name,count)
#puts_file('d:/tmp/log/bin')
require 'benchmark'
Benchmark.bm do |x|
  x.report("bin") {save2bin(bin_file_name,count)}
  x.report("str") {save2str(str_file_name,count)}
end
p 'ok'