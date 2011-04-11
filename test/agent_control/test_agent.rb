require 'test_service'
class TestAgent
  def initialize
    
  end
  def perform(sub_id)
    agent_pid = Process.pid
    p "agent_pid : #{agent_pid}"
    pid_filename = get_pid_filename(__FILE__,sub_id)
    p "pid_filename : #{pid_filename}"
    error_flag = false
    10.times do |i|
      
      @pid = fork do
        Signal.trap("HUP") do
          puts "user cancel!"
          @pid=nil
          exit
        end
        p "test service start: #{sub_id}"
        p "@pid : #{@pid}"
        # 这时的Process.pid已经是进程的pid了。
        p "Process.pid : #{Process.pid}"
        service_pid = Process.pid
        p "service_pid : #{service_pid}"
        file = File.new(pid_filename,'w') 
        file << "agent_pid=#{agent_pid}"+"\n" 
        file << "service_pid=#{service_pid}"+"\n" 
        file.close
        begin
          TestService.perform(sub_id)
        rescue
          puts "get error!"
          error_flag = true
          Process.kill(9,agent_pid)
        end
      end
      # 会等待当前的进程处理完毕
      Process.wait
      p "error_flag : #{error_flag}"
    end
#    p "sleep 70"
#    sleep(70)
  end  
  def stop
    puts "agent stop"
    Process.kill("HUP", @pid)
    Process.wait
  end
  def get_pid_filename(rb_filename, sub_id)
    
    File.join(File.dirname(rb_filename),'pids',File.basename(rb_filename).sub(File.extname(rb_filename),'')+'_'+sub_id.to_i.to_s+'.pid')    
  end
end



# 这时调用stop是没有用的。
if ARGV.size>=0
  if ARGV[0] != 'stop'
    ta = TestAgent.new
    ta.perform(ARGV[0])
  else
    ta.stop
  end
end
