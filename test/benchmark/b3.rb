require 'benchmark'

COUNT = 500_000
puts Benchmark.measure {
  1.upto(COUNT) do 
    a = "1"; 
  end
}
