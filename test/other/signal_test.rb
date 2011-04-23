# 实现对于Linux下信号的响应
# 运行说明：
# 先让本程序运行。
# 在另一个终端上先运行ps -ef|grep ruby查找出pid
# 之后调用kill -usr1 pid
# 就可以看到打印出信息了。
# 有几点要确认AIX和HP上支持哪些中断。
def doit
  puts "start"
  100.times do |index|
    puts index
    sleep(2)
  end
  puts "end"
end

Signal.list
Signal.trap(:USR1) do
  puts "hup"
end
doit
puts "ok"