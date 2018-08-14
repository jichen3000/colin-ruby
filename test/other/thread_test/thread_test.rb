
# thread_1 = Thread.new(10) do |sec|
# 	puts "Thread 1 start... #{sec}"
# 	sleep(sec)
# 	puts "Thread 1 end... #{sec}"

# end
# thread_2 = Thread.new(15) do |sec|
# 	puts "Thread 2 start... #{sec}"
# 	sleep(sec)
# 	puts "Thread 2 end... #{sec}"
# end

# thread_1.join
# puts "join"
# thread_2.join

# puts "ok!"


thread_1 = Thread.new do
    i = 0
    while i < 10
        puts "i: #{i}"
        i += 1
        sleep(1)
    end
	Thread.current[:result] = i

end

sleep(4)
puts thread_1.status
thread_1.exit
puts thread_1.status
puts thread_1[:result]
