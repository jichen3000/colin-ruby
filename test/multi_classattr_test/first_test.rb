require 'class_attr'
require 'pp'

pp "test 1"
5.times do |i|
	sleep(2)
	ClassAttr.add_item('f1'+i.to_s)
	pp ClassAttr.get_arr
end
pp "test 1 ok"
