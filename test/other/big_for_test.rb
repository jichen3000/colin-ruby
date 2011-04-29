class AA
	attr_accessor :a1, :a2
end

arr = []
10.times do |i|
	next if i <5
	str = 'jc'+i.to_s.rjust(8,'0')
	a = AA.new
	a.a1 = str
	a.a2 = a.a1+"jc"
	puts str
	arr << a
end
require "pp"
pp "ok"

