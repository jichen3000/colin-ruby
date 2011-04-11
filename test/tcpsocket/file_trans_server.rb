#author:jiachengxi
require "socket"


class FileTrans
  def initialize(ip,port)
      @descriptors = Array::new
      @serverSocket = TCPServer.new("#{ip}", port)
      @serverSocket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1 )
      printf("Chatserver started on port %d\n", port)
      @descriptors.push( @serverSocket )
  end 
  
  def run
    while true
           sock = @serverSocket.accept
           
           # Received a connect to the server (listening) socket
             # Received something on a client socket
             #if sock.eof? then
               str = sprintf("Client Connencted %s:%s %s %s\n",
                              sock.peeraddr[2], sock.peeraddr[1],sock.peeraddr[3],sock.peeraddr[0])
               printf(str)
               trans_name = sock.recv(10000,0)
               printf("#{trans_name}")
               broadcast_string( trans_name, sock )
               sock.close
               #@serverSocket.delete(sock)
#             else
#              # str = sprintf("[%s|%s]: %s",
#                             # sock.peeraddr[2], sock.peeraddr[1])
#               #print(str)
#               broadcast_string( file_name, sock )
#             end
         end
  end
  private

  def broadcast_string( trans_name, omit_sock )
       file = File.open("#{trans_name}","rb")
       while block=file.read(100000)
         omit_sock.write(block)
       end
       file.close
  end
end

FileTransServer = FileTrans.new("172.16.4.20",2626).run