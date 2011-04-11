#require 'win32/process'
#require 'windows/process'
p "star" 
pid = fork { sleep(10) }   #=> 26557

Process.wait
#def myfork 
#  pid = Process::fork { puts "fork" }   #=> 26557
#pid = Process.fork
#puts "PID1: #{pid}"
#
##child
#if pid.nil?
#   7.times{ |i|
#      puts "Child: #{i}"
#      sleep 1
#   }
#   exit(-1)
#end
#Process.waitpid2(pid)
#end
#myfork
#Process.waitpid2(pid)  if pid.nil?     #=> 26557
#p "end"
#p $?.class           #=> Process::Status
#p $?.to_i            #=> 25344
if not pid.nil? and pid>0
  p pid
  p "ok"
end
