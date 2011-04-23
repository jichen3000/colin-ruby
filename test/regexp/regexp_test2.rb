filename1 = 'ora_log_agent.rb'
filename2 = 'ora_log_agent.log'

rxp = Regexp.new('(ora)_(.*)_agent.rb')
puts rxp
puts rxp.match(filename1)[1]
puts rxp.match(filename1)[2]
puts rxp.match(filename2)

if rxp.match(filename1) 
	filename1.sub!('ora','test')
end
puts filename1

f1 = "mcb_arc_1_68.loit"
f2 = "mcb_arc_1_10366.loit"
f3 = "mcb_arc_1_10367.loit"
arr = []
arr << f1
arr << f2
arr << f3
#rxp = Regexp.new("(mcb_arc_1_)(\\d.*)\.loit")
rxp = /.+_.+_\d+_(\d.*)\..+/
if f1 =~ rxp
	puts "kkk"+$1
end
i_arr = []
arr.each do |item|
	if item =~ rxp
		i_arr << $1.to_i
	end
end
p i_arr
i_arr.sort!
p i_arr.first
p i_arr.last
p "sdfdsf : #{i_arr.first}"