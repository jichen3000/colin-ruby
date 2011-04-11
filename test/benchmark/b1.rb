require 'benchmark'
# 用给定的表达式"a"*1_000_000构造字符串来测量时间
# 这个报告显示我们的CPU时间，系统CPU时间，用户和系统CPU时间总数，和流逝的真正时间。时间单元是秒。
puts Benchmark.measure { "a"*1_000_000 }
#puts "a"*1_00
#p "ok"