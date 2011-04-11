stop = {}
3.times do |index|
  stop[index] = false
  Thread.new do
    while true
      if stop[index]
        puts "thread #{index} stop"
        break
      end
    end
  end
end

sleep(1)
stop[1] = true
sleep(1)
stop[2] = true
sleep(1)
stop[0] = true

#Thread.list.each {|x| p x;x.join}

p "ok"