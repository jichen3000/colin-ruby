def get_arr_9
  [1,2,3,4,5,6,7,8,9]
end
def get_arr_9_9
  get_arr_9.map {get_arr_9}
end
def be_subed_arr_9(arr)
  get_arr_9 - arr
end
def deep_copy(object)
  Marshal.load(Marshal.dump(object))
end
#def subset_arrs(arrs)
#  arrs.reduce(:&)
#end
class A
  attr :arr
  def initialize(arr)
    p arr
    @arr = arr
  end
end

#arr = [1,2]
#a = A.new(arr)
#b = deep_copy(a)
#a.arr << [3]
#p a.arr
#p a.arr.object_id
#p b.arr
#p b.arr.object_id

#barr = (1..4).reduce([5,6]) do |arr,i|
#  if i%2 == 0
#    arr << i
#  end
#  arr
#end
#p barr