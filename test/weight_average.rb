def get_split_arr(value_arr, split_count_arr)
#  sort_arr = value_arr.sort
#  middle_index = (weight_item[0]/2).to_i
#  min = min_weight*
  new_arr = []
  (split_count_arr.size-1).times do |index|
    new_arr[index] = []
  end
  
  value_index = 0
  while value_index < split_count_arr[split_count_arr.size-1]
    (split_count_arr.size-1).times do |split_index|
      if value_index < split_count_arr[split_index]
        new_arr[split_index] << value_arr[value_index]
      end
    end
    value_index += 1
  end
  new_arr[split_count_arr.size-1] = value_arr
#  test
#  p_new_arr(new_arr)
  
  
  
  return new_arr
end
def get_weight_average(sub_value_arr, weight_arr, min_weight, max_weight)
  weight_average = 0 
  sub_index = 0
  pre_average = 0
  sub_value_arr.each do |sub_arr|
    sub_arr.sort!
    middle = sub_arr[(sub_arr.size/2).to_i]
    min = min_weight * middle
    max = max_weight * middle
    
    count = 0
    sum = 0
    sub_arr.each do |value|
      if value > min and value < max
        sum += value
        count += 1
      end
    end
#    p "sub_index:#{sub_index}"
#    p sub_arr
#    p "count:#{count} sum:#{sum}"
    if count>0
      pre_average = sum/count
      weight_average += pre_average * weight_arr[sub_index]
    else
      weight_average += pre_average * weight_arr[sub_index]
    end 
#    p "weight_average:#{weight_average}"
#    sub_index += 1 
  end
  return weight_average
end
def p_new_arr(arr)
  arr.each_with_index do |sub_arr,index|
    p "index:#{index}"
    p sub_arr
  end
end
def gen_rand_arr(size,min,max)
  arr = []
  size.times do |idnex|
    arr << min+rand(max-min)
  end
  arr
end
#value_arr = gen_rand_arr(26,21,40)
value_arr = [36, 10, 24, 26, 36, 81, 32, 
  26, 90, 27, 39, 05, 35, 22, 35, 
  34, 21, 37, 35, 27, 99, 31, 06, 26, 34, 34, 36, 37, 36, 83]
split_count_arr = [7,15,30]
weight_arr = [0.5, 0.3, 0.2]
p value_arr.size
sub_value_arr = get_split_arr(value_arr, split_count_arr)
get_weight_average(sub_value_arr, weight_arr, 0.5, 2)