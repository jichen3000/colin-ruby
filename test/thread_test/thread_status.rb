t1 = Thread.new do
  2.times do |i|
    puts "1:#{i}"
    sleep(1)
  end
  p "1:over"
end

t2 = Thread.new do
  6.times do |i|
    puts "2:#{i}"
    sleep(1)
  end
  p "2:over"
end

20.times do |i|
  puts "index #{i}check:thread1:#{t1.alive?} thread2:#{t2.alive?}"
  sleep(0.5)
end

p "ok"

