require 'benchmark'
include Benchmark          # we need the CAPTION and FMTSTR constants
# benchmark(caption = "", label_width = nil, fmtstr = nil, *labels)
n = 50000
Benchmark.benchmark(" "*7 + CAPTION, 7, FMTSTR, ">total:", ">avg:") do |x|
  tf = x.report("for:")   { for i in 1..n; a = "1"; end }
  tt = x.report("times:") { n.times do   ; a = "1"; end }
  tu = x.report("upto:")  { 1.upto(n) do ; a = "1"; end }
  [tf+tt+tu, (tf+tt+tu)/3]
end
