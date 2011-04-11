require 'net/ssh'
Net::SSH.start('172.16.4.28', 'root', :password => "root") do |ssh|
  puts ssh.exec!("hostname")
end
p "ok"

