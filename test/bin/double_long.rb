

def puts_int(int)
  puts "value:#{int}, class:#{int.class}, size:#{int.size}"
end
def int_to_arr(int)
  if (int.size<=4)
    return [0,int]
  else
    return int.divmod($big)
  end
end
$big = 2**32
puts_int($big)
little = $big -1
puts_int(little)
little = 2**16 -1
puts_int(little)
puts_int(2)

p int_to_arr($big)
p int_to_arr($big).pack('NN')

arr = ([4,5,6] + int_to_arr($big) << 2 +[0,0])
p arr
puts "ok"