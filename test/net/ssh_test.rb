require 'net/ssh'

Net::SSH.start('172.16.4.129','root',:password=>'root') do |ssh|
  ssh.exec!("cd /home/colin")
  ssh.exec("pwd")
  shell = ssh.shell.open
  shell.cd '/home/colin'
  ssh.exec("pwd")
end

p "ok"