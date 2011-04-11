require 'socket'

port = 12345
host = 'localhost'
session = TCPSocket.new(host,port)
time = session.gets
puts "server time: #{time}"
session.puts("client received the time!")
session.close

puts "client over!"
