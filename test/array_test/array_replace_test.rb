require 'pp'

arr = ['12','23','34']
pp arr
brr = arr.map do |item|
  item + 'jc'
end

pp arr
pp brr

arr.map! do |item|
  "ksjdfkdjk"
  'jc'
end
pp arr
