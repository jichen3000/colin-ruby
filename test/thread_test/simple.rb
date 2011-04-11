thread_arr = []
2.times do |index|
  thread = Thread.new do
    100.times {|x| puts "thread:#{index}, No:#{x}";sleep(1)}
  end
  thread_arr << thread
end
thread_arr.each {|x| x.join}
p "ok"