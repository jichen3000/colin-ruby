
=begin
`mkfifo jc`

fp = open 'jc', File::RDWR
fp.syswrite("jc")

fp = open 'jc', File::RDWR
fp.sysread

require 'net/ftp'
require 'ftp_exp'
ftp = Net::FTP.open('172.16.4.28','root','root')
ftp.chdir("/home/dbra10g/colin")
ftp.putbinaryfile_exp("pipe200", "pipe28",5)
fp200 = open('pipe200', File::RDWR)
ftp.putbinaryfile("pipe200", "jc",5)
ftp.putbinaryfile("pipe200", "pipe28",5)
ftp.storbinary("STOR pipe28",fp200, 512)
可以使用ftp通过管道来走。
但是管道，

fp200.sysread(512)
require 'net/ftp'
require 'ftp_exp'
ftp = Net::FTP.open('172.16.4.200','root','root')
ftp.chdir("/home/dbra10g/colin")
ftp.putbinaryfile_exp("pipe28", "pipe200",1048576)
=end