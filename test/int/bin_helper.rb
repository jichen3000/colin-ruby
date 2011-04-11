# 生成全 1的二进制数字表
# 第一个长度和最后一个长度特殊
# 例：gen_table_some(64,16)
#"index:0,item_size:63,item:111111111111111111111111111111111111111111111111111111111111111"
#"index:1,item_size:16,item:1111111111111111"
#"index:2,item_size:32,item:11111111111111110000000000000000"
#"index:3,item_size:48,item:111111111111111100000000000000000000000000000000"
#"index:4,item_size:63,item:111111111111111000000000000000000000000000000000000000000000000"
def gen_table_some(full_size,size)
  arr = []
  arr << (1<<(full_size-1))-1
  (full_size/size).times do |index|
    # last will sepcial
    if index < (full_size/size) - 1
      arr << ((1<<size*(index+1))-1 - ((1<<size*(index))-1))
    else      
      arr << ((1<<(size*(index+1)-1))-1 - ((1<<size*(index))-1))
    end
  end
  arr
end
# 生成1的二进制数字表
# 最后一个不用生成的
#例：gen_table_some(4)
#"index:0,item_size:1,item:1"
#"index:1,item_size:2,item:10"
#"index:2,item_size:3,item:100"
def gen_table_full(size)
  arr = []
  (size-1).times do |index|
    arr << (1<<index)
  end  
  arr
end
def p_bin_arr(arr)
  arr.each_with_index do |item,index|
    p "index:#{index},item_size:#{item.to_s(2).length},item:#{item.to_s(2)}"
  end
end
p_bin_arr(gen_table_some(64,16))
p_bin_arr(gen_table_full(64))
