#TO22 = 4194304
#p TO22.class
#p 1.class
#
#p (10&2)
#
#p (1<<30)
#p ((1<<30)-1).class
#p (1<<1)
#arr = []
#512.times do |index|
#  arr << (1<<index)
#end
#p arr
#
#require 'benchmark'
#Benchmark.bm do |item|
#item.report("rand") {100000.times{rand(512)}}
#item.report("512") {100000.times {|i| 1<<(rand(512)+400)}} 
#end
#
def gen(start_,end_)
  start_.upto(end_) do |index|
    puts '0001 ' + index.to_s(16).rjust(8,'0') 
  end
end
gen(200,500)