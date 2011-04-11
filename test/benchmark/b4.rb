# 一些时间的花费依赖于它执行的次数。这些差别是由内存分配和垃圾回收的花费产生的。
# 要避免这些差异，提供了bmbm方法。例如，排序一个浮点数组的比较方式：

require 'benchmark'

array = (1..1000000).map { rand }

Benchmark.bmbm do |x|

x.report("sort!") { array.dup.sort! }

x.report("sort") { array.dup.sort }

end