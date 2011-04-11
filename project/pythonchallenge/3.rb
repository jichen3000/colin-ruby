path = File.dirname(__FILE__)
file = File.open(File.join(path,"3.txt"))
hash = {}
line = "AAAbAAA"
#if line =~ /([A-Z]{3}[a-z][A-Z]{3})/
#  p $1
#end
result = ""
rex = /([a-z][A-Z]{3}([a-z])[A-Z]{3}[a-z])/
file.readlines.each do |line|
  if line =~ rex
    p $1
    result += $2
  end
end
p result
#p hash
#arr = hash.sort{|a,b|a[1]<=>b[1]}
#arr.each do |pare|
#  puts pare[0].chr.to_s+"\t"+pare[1].to_s
#end
# yqtiulae
# equality
p "ok"