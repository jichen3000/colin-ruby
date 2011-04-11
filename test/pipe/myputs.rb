# 使用puts，会使popen.rb中不能实时打印出来！
1111115.times do |index|
#  $stdout.puts "index:#{index}"
  p "index:#{index}"
#  printf "index:#{index}\n"
#  puts "index:#{index}\n"
#  $stdout.flush
  sleep(0.4)
end
puts "end!!!"