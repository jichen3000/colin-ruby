
thread_1 = Thread.new(10) do |sec|
	puts "Thread 1 start... #{sec}"
	sleep(sec)
	puts "Thread 1 end... #{sec}"
	
end
thread_2 = Thread.new(15) do |sec|
	puts "Thread 2 start... #{sec}"
	sleep(sec)
	puts "Thread 2 end... #{sec}"
end

thread_1.join
puts "join"
thread_2.join

puts "ok!"