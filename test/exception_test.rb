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
#  data = socket.read(512)
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
  # .. process stuff
rescue ColinError => detail
  puts detail.message
#  print detail.backtrace.join("\n")
#  retry if detail.ok_to_retry
#  raise
ensure
	puts "ensure"
end