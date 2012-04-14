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
