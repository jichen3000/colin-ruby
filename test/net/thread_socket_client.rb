require 'socket'
class SendMessage
  @@session = nil
  @@mutex = Mutex.new
  def self.run(message)
    @@mutex.lock
    if @@session==nil
      @@session = TCPSocket.new('localhost',12345)
      p @@session
      puts @@session.gets
    end
    @@mutex.unlock
    puts "It will send: #{message}"
    @@session.puts message
  end
end

thread1 = Thread.new do
  puts "tread1 start"
  i = 0
  while true
    SendMessage.run("thread 1 index #{i}")
    sleep(2)
    i += 1
  end
end

thread2 = Thread.new do
  puts "tread2 start"
  i = 0
  while true
    SendMessage.run("thread 2 index #{i}")
    sleep(3)
    i += 1
  end
end

thread1.join
p "ok"

