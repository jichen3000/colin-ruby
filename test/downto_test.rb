
arr = []
5.times {|i| arr << i;puts i}
p "arr.size : #{arr.size}"

3.downto(2) {|i| puts "del index(#{i}), del value(#{arr[i]})";arr.delete_at(i)}
#2.upto(3) {|i| puts "del index(#{i}), del value(#{arr[i]})";arr.delete_at(i)}

p arr