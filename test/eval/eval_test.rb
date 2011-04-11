p eval(' 90 > 80')
data = []
data[1] = 0
#p eval("puts data[1]",binding())
#p eval("puts #{data[1]}")
p eval("puts data[1]")
p eval("data[1] > 80")
p "ok"

hash = {"/ora"=>[23,45],"/oradata"=>[90,80]}
def avg(hash,col_index)
#  sum = 0
#  hash.keys.each do |key|
#    sum += hash[key][col_index]
#  end
#  sum/hash.keys.size
  p hash
  p col_index
  100
end
def sum(hash,col_index)
end
def max()
end
p eval("avg(hash,1) > 80")

"#group_default"
