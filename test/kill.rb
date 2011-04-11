if ARGV.size < 1
  puts "usag: need process name"
  exit
end

process_name = ARGV[0]

arr =  IO.popen("ps -ef|grep #{process_name}")
#if arr==""
#  puts "no process need kill!"
#  exit
#end
arr.each do |item|
  pid = item.split(" ")[1]
  system("kill -9 #{pid}")
  puts "killed #{pid}!"
end
system("ps -ef|grep #{process_name}")
puts "ok"      
