require 'net/ftp'

#ftp = Net::FTP.open('172.16.4.37','hzmc','hzmc')
ftp = Net::FTP.open('172.16.4.98','root','root')
p ftp.status
#ftp.mkdir("colin1")
#ftp.chdir('/home/colin')
p ftp.size('/home/alfredxu/test/1.txt')
p "$0:#{$0}"
p ENV

begin
  ftp.size('/home/alfredxu/test/1111.txt')
rescue Net::FTPPermError => e
  puts "file not exist!"
end
p ftp.ls('/home/alfredxu/test/1.txt')
p ftp.ls('/home/alfredxu/test/1111.txt')
#ftp.put("D:/tmp/log/S_8.txt",'/home/colin/345')
p "ok"