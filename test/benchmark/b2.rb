require 'benchmark'

n = 50000
Benchmark.bm do |x|
  x.report { for i in 1..n; a = "1"; end }
  x.report { n.times do ; a = "1"; end }
  x.report { 1.upto(n) do ; a = "1"; end }
end