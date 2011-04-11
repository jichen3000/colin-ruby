require 'net/sftp'

sftp = Net::SFTP.start('172.16.4.28','dbra', :password => 'mcdbra')
p "start"
sftp.upload!("D:/down/linux/lfslivecd-x86-6.3-r2160.iso",'/home/colin/lfslivecd-x86-6.3-r2160.iso')
p "sftp.closed?:#{sftp.closed?}"
sftp.close_channel
p "sftp.closed?:#{sftp.closed?}"
puts "ok"