arr = [1,2,3,4]

(arr.size - 1 ).downto(0) do |i|
  p i
  p arr.delete_at(i)
  
end