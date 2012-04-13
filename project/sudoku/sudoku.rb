def main
  # you must input initial value in start_arr.
  start_arr = [
    %w(9 0 0 0 0 0 0 0 5),
    %w(0 4 0 3 0 0 0 2 0),
    %w(0 0 8 0 0 0 1 0 0),
    %w(0 7 0 6 0 3 0 0 0),
    %w(0 0 0 0 8 0 0 0 0),
    %w(0 0 0 7 0 9 0 6 0),
    %w(0 0 1 0 0 0 9 0 0),
    %w(0 3 0 0 0 6 0 4 0),
    %w(5 0 0 0 0 0 0 0 8)
  ]  
  start_arr.map! {|arr| arr.map!{|x| x.to_i}}
  result_map, empty_points_arr, unshow_values_by_x_arr, unshow_values_by_y_arr,
      unshow_values_by_group_arr, group_null_point_arr = init(start_arr)
  #p result_map
  result_map = answer(result_map, empty_points_arr, unshow_values_by_x_arr, unshow_values_by_y_arr, unshow_values_by_group_arr, group_null_point_arr)
  puts "The answer is:"
  show_map(result_map)
end
def init(start_arr)
  unshow_values_by_x_arr = get_arr_9_9
  unshow_values_by_y_arr = get_arr_9_9
  unshow_values_by_group_arr = get_arr_9_9
  result_map = {}
  empty_points_arr = []
  group_null_point_arr = get_arr_9.map {[]}
  start_arr.each_with_index do |sub_arr,y_index|
    sub_arr.each_with_index do |value,x_index|
      group_index = compute_group_index(x_index,y_index)
      if exist_value?(value)
        set_value(result_map, value, x_index, y_index, group_index, unshow_values_by_x_arr,  unshow_values_by_y_arr, unshow_values_by_group_arr, group_null_point_arr)
      else
        empty_points_arr << [x_index,y_index,group_index]
        group_null_point_arr[group_index] << [x_index,y_index]
      end
    end    
  end
  [result_map, empty_points_arr, unshow_values_by_x_arr, unshow_values_by_y_arr, unshow_values_by_group_arr, group_null_point_arr]
end
def show_map(map)
  arr = change_to_arr(map)
  arr.each do |i|
    p i
  end
end
def exist_value?(value)
  value >0 and value <10
end
def set_value(result_map, value, x_index, y_index, group_index, unshow_values_by_x_arr,  unshow_values_by_y_arr, unshow_values_by_group_arr, group_null_point_arr)
  result_map[[x_index,y_index]]=value
  unshow_values_by_x_arr[x_index].delete(value)
  unshow_values_by_y_arr[y_index].delete(value)
  unshow_values_by_group_arr[group_index].delete(value)
  group_null_point_arr[group_index].delete([x_index,y_index])
  value
end
def compute_group_index(x_index,y_index)
  x_index/3*3+y_index/3
end
def get_arr_9
  [1,2,3,4,5,6,7,8,9]
end
def get_arr_9_9
  get_arr_9.map {get_arr_9}
end
def be_subed_arr_9(arr)
  get_arr_9 - arr
end
def get_possible_values(x_index,y_index,group_index, unshow_values_by_x_arr, unshow_values_by_y_arr, unshow_values_by_group_arr)
  unshow_values_by_x_arr[x_index] & unshow_values_by_y_arr[y_index] & unshow_values_by_group_arr[group_index]
end
def exlude_by_other_row_col(possible_values,group_null_point_arr,x_index,y_index,group_index, unshow_values_by_x_arr, unshow_values_by_y_arr)
  result_values = []
  possible_values.each do |possible_value|
    current_group_null_points = group_null_point_arr[group_index]
    exlude_row_points = computer_exlude_x_points(x_index, y_index, unshow_values_by_x_arr, unshow_values_by_y_arr,  possible_value)
    exlude_col_points = computer_exlude_y_points(x_index, y_index, unshow_values_by_x_arr, unshow_values_by_y_arr,  possible_value)
    remain_points = current_group_null_points - 
        exlude_row_points - exlude_col_points
    if remain_points.size == 1
      result_values << possible_value
    end
  end
  result_values
end
def computer_exlude_x_points(x_index, y_index, unshow_values_by_x_arr, unshow_values_by_y_arr,  possible_value)
  x_index_arr = get_same_group_index_arr(x_index)
  x_index_arr.delete(x_index)
  x_index_arr.delete_if do |index|
    unshow_values_by_x_arr[index].include?(possible_value)
  end
  y_index_arr = get_same_group_index_arr(y_index)
  x_index_arr.product(y_index_arr)
end
def computer_exlude_y_points(x_index, y_index, unshow_values_by_x_arr, unshow_values_by_y_arr,  possible_value)
  y_index_arr = get_same_group_index_arr(y_index)
  y_index_arr.delete(y_index)
  y_index_arr.delete_if do |index|
    unshow_values_by_y_arr[index].include?(possible_value)
  end
  x_index_arr = get_same_group_index_arr(x_index)
  x_index_arr.product(y_index_arr)
end
def get_same_group_index_arr(origin_index)
  base_index = origin_index/3 *3
  index_arr = [0,1,2].map {|x| x+base_index}
end
def subset_arrs(arrs)
  arrs.reduce(:&)
end
$answer_iteration_count = 0
$answer_count = 0
def answer(result_map, empty_points_arr, unshow_values_by_x_arr, unshow_values_by_y_arr, unshow_values_by_group_arr, group_null_point_arr)
  del_arr = []
  method_name = ""
  empty_points_arr.each do |x_index,y_index,group_index|
    possible_values = get_possible_values(x_index,y_index,group_index, unshow_values_by_x_arr, unshow_values_by_y_arr, unshow_values_by_group_arr)
    if possible_values.size == 1
      method_name = 'get_possible_values'
    end
    if possible_values.size > 1
      subset_values = exlude_by_other_row_col(possible_values,group_null_point_arr,x_index,y_index,group_index, unshow_values_by_x_arr, unshow_values_by_y_arr)
      if (subset_values.size > 1)
        puts "logic error"
        exit
      end
      possible_values = subset_values
      if possible_values.size == 1
        method_name = 'exlude_by_other_row_col'
      end
    end
    if possible_values.size == 1
      value = possible_values.first
      set_value(result_map, value, x_index, y_index, group_index, unshow_values_by_x_arr,  unshow_values_by_y_arr, unshow_values_by_group_arr, group_null_point_arr)
      del_arr << [x_index,y_index,group_index]
      $answer_count += 1
      puts "NO:#{$answer_count} value: #{value} has added at (#{x_index},#{y_index}) by #{method_name} in #{$answer_iteration_count+1} iteration."
    end
  end
  $answer_iteration_count += 1
  if del_arr.size == 0
    p "I cannot deal with this situation!"
    p "$answer_iteration_count:", $answer_iteration_count
    p "$answer_count:", $answer_count
    p "empty_points_arr:", empty_points_arr
    return result_map
  end
  empty_points_arr -= del_arr
  if empty_points_arr.size > 0
    answer(result_map, empty_points_arr, unshow_values_by_x_arr, unshow_values_by_y_arr, unshow_values_by_group_arr, group_null_point_arr)
  end
  result_map
end
def change_to_arr(map)
  result_arr = []
  9.times {|i| result_arr[i]=[0,0,0,0,0,0,0,0,0]}
  map.each do |key,value|
    result_arr[key[1]][key[0]]=value
  end
  result_arr
end

main
p "ok"