#author:jiachengxi
require "socket"

class FileTransClient
  def initialize(ip,port,source_name,dest_name)
      puts "start"
      streamSock = TCPSocket::new( "#{ip}", port )
      streamSock.write( "#{source_name}" )
      begin_time=Time.now
      file = File.open("#{dest_name}","wb") 
      block = streamSock.read()
      file.write(block)
      file.close
      streamSock.close
      puts "end"
      puts Time.now-begin_time
      
  end 
  def run
    
  end
end
FileTransClient.new("172.16.4.20",2626,"d://tmp//ruby.tar","d://ruby.tar.bak")
#FileTransClient.new("172.16.4.33",6666,"d://WORK_HOME//henry-web.7z","d://henry-web.7z")