class TestException < RuntimeError
  attr :ok_to_retry
  def initialize(ok_to_retry)
    @ok_to_retry = ok_to_retry
  end
end

class ColinError < StandardError
  
end
def read_data(socket)
  data = socket.read(512)
  if data.nil?
    raise TestException.new(true), "transient read error"
  end
  # .. normal processing
end
def read_data2
  data = nil
  # data = socket.read(512)
  if data.nil?
    raise TestException.new(true), "transient read error"
  end
  # .. normal processing
end
def read3
  read_data2
end

begin
  stuff = read3
  # 1 / 0
  # .. process stuff
rescue TestException => detail
  puts "some"
  puts detail.message
  # raise
 # print detail.backtrace.join("\n")
#  retry if detail.ok_to_retry
#  raise
ensure
	puts "ensure"
end