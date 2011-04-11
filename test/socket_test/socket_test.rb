require 'socket'
begin
session =  TCPSocket.new('1.1.1.1',1111)
session.puts info
rescue Exception => e
  p e.instance_of?(Errno::ETIMEDOUT)
end
