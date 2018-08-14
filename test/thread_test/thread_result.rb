new_thread = Thread.new do
    sleep 3
    Thread.current[:result] = 5
    
end
puts "some"
new_thread.join
puts new_thread[:result]