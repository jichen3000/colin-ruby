require 'net/ssh'
require 'net/sftp'

filename = 'input_ps.rb'
to_dir = '/home/colin/test'
from_filename = File.join(File.dirname(__FILE__),filename)
to_filename = File.join(to_dir,filename)
## 加!号表示方法是同步的。否则是异步的。
Net::SSH.start('172.16.4.200','dbra',:password => "mcdbra") do |ssh|
  ssh.exec(". ~/.bash_profile")
  ssh.exec("cd /home/colin/test")
#  puts ssh.exec!("env")
  puts ssh.exec!("pwd")
  ssh.sftp.upload!(from_filename,to_filename)
  puts ssh.exec!("ruby #{filename}")
end
#Net::SFTP.start('172.16.4.200','root', :password => 'root') do |sftp|
#  sftp.upload!(from_filename,to_filename)
#end

p "ok"