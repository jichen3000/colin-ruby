20.upto(100) do |x|
	0.upto(50) do |y|
		0.upto(30) do |z|
			if (x+20*y+30*z)==1000 and (x+y+z) == 100
				puts "x:#{x} y:#{y} x:#{z} "
			end
		end
	end
end

puts 'ok'