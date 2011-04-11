require 'socket'

port = 12345
server = TCPServer.new(port)

puts "server start!(port:#{port})"
while (session = server.accept)
  puts "session open#{session}"
  session.puts(Time.new)
  while re = session.gets
    puts re
  end
  
  session.close
  puts "session close#{session}"
end

p "ok"