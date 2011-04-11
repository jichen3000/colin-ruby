arr = [1,2,3,4]
new_arr = []
arr.each do |i|
  new_arr << i
end

new_arr << arr[0]
new_arr << arr[1]

p new_arr
new_arr[0] = 78
p new_arr
p "ok"

arr = [[1,1],[2,2],[3,3],[4,4]]
new_arr = []
arr.each do |i|
  new_arr << i
end

new_arr << arr[0]
new_arr << arr[1]

p new_arr
arr[0] = [7,7]
#new_arr[0] = [78,78]
p new_arr
p "ok"

arr = [[1,1],[2,2],[3,3],[4,4]]
new_arr = []
arr.size.times do |i|
  new_arr[i]=arr[i]
end

new_arr[4] = arr[0]
new_arr[5] = arr[1]

p new_arr
arr[0] = [7,7]
#new_arr[0] = [78,78]
p new_arr
p "ok"
