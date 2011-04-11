require 'win32/process'
@pid = fork do
  Signal.trap("HUP") do
    puts "user cancel!"
    @pid=nil
    exit
  end
  p "fork start"
  service_pid=Process.pid
  sleep(10)
  puts service_pid
end
p "main"
puts @pid
sleep(20)
Process.wait
p "ok"