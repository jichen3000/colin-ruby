p '0101'.to_i(2)
p 10.to_s(2)
p 7.to_s(2)

p ('0101'.to_i(2) >> 2)

# equal
p (10%8)
p (10&7)
# equal
p (10/8)
p (10>>3)
p (3027346/8192)
p (3027346>>13)

def gen_arr(size)
  arr = []
  size.times do |i|
    arr << rand(4194303)    
  end
  arr
end

require 'benchmark'
#arr = gen_arr(1000_0000)
#Benchmark.bm do |item|
#  item.report("div") {arr.each{|i| i/8192}}
#  item.report(">>") {arr.each{|i| i >> 13}}
#  item.report("div") {arr.each{|i| i/4}}
#  item.report("div") {arr.each{|i| i/3}}
#  item.report(">>") {arr.each{|i| i >> 2}}
#end
#Benchmark.bm do |item|
#  item.report("mod") {arr.each{|i| i%8192}}
#  item.report("&") {arr.each{|i| i & 8191}}
#end

i = (1<<512)
p i.to_s(2)
p i.to_s(2).length
p i.size
p (1<<30-1).class
p (1<<30-1).size
p (1<<30).class
p (1<<30).size
p (1<<31).class
p (1<<31).size
p (1<<32-1).class
p (1<<32-1).size
