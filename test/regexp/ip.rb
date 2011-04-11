ip = 'server.host=172.16.4.4'
if ip =~ /server.host=(.+)/
  p $1
end

p "ok"