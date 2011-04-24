def what_can_i_do?
  sys = Process::Sys
  puts "UID=#{sys.getuid},GID=#{sys.getgid}" 
  puts Process.pid 
end

what_can_i_do?
p "ok"
