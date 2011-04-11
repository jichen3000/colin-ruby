arr = [5,10,20,40,80]
hash = {}
arr.each do |item|
  hash[item] = item * 200
end
p hash

r_arr = []
logs = [6,70,30,50,100,4]
logs.each do |item|
  hash.keys.sort.each do |cur_size|
    if item < cur_size
      r_arr << hash[cur_size]
      break
    end
  end
end

p r_arr
p "ok"