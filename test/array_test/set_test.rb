require 'set'

arr = [1, 2, 7, 1, 1, 5, 2, 5, 1]
brr = arr.to_set
p brr

s = Set.new((1..10).collect)
p s
p s.divide { |x| x < 5 }
