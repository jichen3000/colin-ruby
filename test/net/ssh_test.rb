require 'net/ssh'
require 'testhelper'

Net::SSH.start('qa-host','root',:password=>'fortigate') do |ssh|
  ssh.exec("pwd")
  ssh.exec("cd /home")
  ssh.exec("pwd")
  # shell = ssh.shell.open
  # shell.cd '/home'
  # ssh.exec("pwd")
end

# ssh = Net::SSH.start('qa-host','root',:password=>'fortigate')
# ssh.exec("pwd")
# # ssh.pt
# ssh.exec("cd /home")
# ssh.exec("pwd")
# ssh.close

def return_client()
    Net::SSH.start('qa-host','root',:password=>'fortigate')
end

CLIENT = return_client()
puts CLIENT.exec!("pwd")
puts CLIENT.exec!("cd /home")
puts CLIENT.exec!("pwd")

CLIENT.open_channel do |channel|
    channel.request_pty
    puts channel.exec("pwd")
    puts channel.exec("cd /home")
    puts channel.exec("pwd")
    channel.wait
end

ssh = Net::SSH.start('10.160.13.29','admin')

at_exit do
    CLIENT.close
end
p "ok"