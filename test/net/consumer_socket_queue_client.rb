require 'socket'
class SendMessage
  @@session = nil
  @@mutex = Mutex.new
  @@buffer = Queue.new()
  @@max = 3
  def self.run()
#    @@mutex.lock
    if @@session==nil
      @@session = TCPSocket.new('localhost',12345)
      p @@session
      puts @@session.gets
    end
#    @@mutex.unlock
    message = @@buffer.deq
    puts "It will send: #{message}"
    @@session.puts message
  end
  def self.add_buffer(message)
    @@mutex.synchronize do 
      if @@buffer.size < @@max
        puts "before add! size:#{@@buffer.size}"
        @@buffer.enq(message)
      else
        puts "it will drop message! size:#{@@buffer.size}"
      end
    end
  end
end




thread1 = Thread.new do
  puts "tread1 start"
  i = 0
  while true
    SendMessage.add_buffer("thread 1 index #{i}")
    sleep(2)
    i += 1
  end
end

thread2 = Thread.new do
  puts "tread2 start"
  i = 0
  while true
    SendMessage.add_buffer("thread 2 index #{i}")
    sleep(3)
    i += 1
  end
end

thread_consumer = Thread.new do
  puts "thread_consumer start"
  i = 0
  sleep(10)
  while true
    puts "run #{i}"
    SendMessage.run
    i += 1
  end
end

thread1.join
p "ok"
