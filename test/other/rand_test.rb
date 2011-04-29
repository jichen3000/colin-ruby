#require 'rand'
rand(10000)

a = rand(100)
p a
#b = Random::Array.new
arr = [1,4,7]
b = arr.delete_at(rand(arr.size))
p b
p arr

def check_arr(arr)
  if arr.size != 4
    raise "length is must 4!"
  end    
  Integer(arr.join)
  if arr.uniq.size != 4
    raise "has repeat number!"
  end
end
#check_arr([1,1,2,3])
#check_arr([1,"zx",2,3])
check_arr([1,2,3,5])