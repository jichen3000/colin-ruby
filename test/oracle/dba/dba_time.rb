require 'benchmark'
require 'dba_class'
array_i = Dba.gen_rand_dba_array(100000)
array = array_i.map{|i| Dba.dba_itos8(i)}

Benchmark.bm do |x|
  x.report("ana4i") { array_i.map{|i| Dba.ana4i(i)} }
  x.report("ana4s") { array.map{|i| Dba.ana4s(i)} }
  x.report("ana_old") { array.map{|i| Dba.ana_old(i)} }
end

# result on colin machine
# dba count 10000000
#user     system      total        real
#ana4i 19.140000   0.813000  19.953000 ( 28.328000)
#ana4s 29.594000   1.187000  30.781000 ( 59.047000)
#ana_old 69.937000   0.641000  70.578000 ( 73.172000)