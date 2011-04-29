require 'net/ftp'

#ftp = Net::FTP.open('172.16.4.37','hzmc','hzmc')
ftp = Net::FTP.open('172.16.4.28','dbra','mcdbra')
p ftp.status
#ftp.mkdir("colin1")
#ftp.chdir('/home/colin')
ftp.putbinaryfile("D:/tmp/log/S_8.txt",'/home/colin/345')
p "ok"