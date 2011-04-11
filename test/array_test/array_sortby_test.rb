arrays = [[1,2,3], [100], [10,20]]  
p arrays.sort_by { |x| x.size }
p arrays
x = 1
y = 2
p x <=> -1
p x,y

p [1, 100, 42, 23, 26, 10000].sort do |x, y|
#  p "...."
#  p x,y
  x == 42 ? 1 : x <=> y
#  p x,y
#  x
end

