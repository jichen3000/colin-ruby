#begin
#  File.open("mm.txt")
#rescue => e
#  p e
#  p e.class.name
#  puts e.message+"(#{e.class.name})\n"+e.backtrace.join("\n")
#end
require 'net/ftp'
#begin
#  ftp = Net::FTP.open('17.1.1.1','','')
#rescue Errno::ETIMEDOUT => e
#  puts e.message+"(#{e.class.name})\n"+e.backtrace.join("\n")
#end

#begin
#  ftp = Net::FTP.open('172.16.4.37','ll','')
#rescue Net::FTPPermError => e
#  puts e.message+"(#{e.class.name})\n"+e.backtrace.join("\n")
#end
## 421 Timeout (900 seconds): closing control connection.

#
#begin
#  ftp = Net::FTP.open('172.16.4.37','root','mc')
#rescue Net::FTPPermError => e
#  puts e.message+"(#{e.class.name})\n"+e.backtrace.join("\n")
#end

p File.exist?("D:\tools\eclipse-3.5")
p File.directory?("D:\tools\eclipse-3.5")
begin
  ftp = Net::FTP.open('172.16.4.37','root','mchzroot')
  ftp.size('\rootdddd')
rescue Net::FTPPermError => e
  puts e.message+"(#{e.class.name})\n"+e.backtrace.join("\n")
end
p "ok"
# 421 Timeout (900 seconds): closing control connection.
