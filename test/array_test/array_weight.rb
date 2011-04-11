def avg_with_weight(value_arr, weitht_arr)
  if value_arr[0]<=0
    return 0
  end
  sum = 0
  value_arr.size.times do |index|
    if value_arr[index]<=0
      value_arr[index] = value_arr[index-1]
    end
    sum += value_arr[index] * weitht_arr[index]
  end
  sum
end

v_arr = [1000,0,10]
w_arr = [0.5,0.3,0.2]

p avg_with_weight(v_arr,w_arr)