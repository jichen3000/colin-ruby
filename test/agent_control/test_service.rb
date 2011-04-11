
class TestService
  def self.perform(sub_id)
    p "test service"
    p "sub_id : #{sub_id}"
    p "process.pid : #{Process.pid}"
    raise(StandardError,"there is Exception")
    sleep(3)
    p "service over"
  end  
end