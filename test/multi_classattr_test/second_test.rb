require 'class_attr'
require 'pp'

pp "test 2"
5.times do |i|
	sleep(2)
	ClassAttr.add_item('f2'+i.to_s)
	pp ClassAttr.get_arr
end
pp "test 2 ok"
