class ColinError < StandardError
    def initialize(msg)
        @msg = msg
    end
    def message()
        "Colin Error: #{@msg}"
    end
end

def get_colin_error
  raise ColinError.new("colin error")
end

begin
  get_colin_error
rescue ColinError => detail
  # require 'pry';binding.pry
  puts detail.message
  # require 'pry';binding.pry
  
  # 不能调用本句
  puts detail.backtrace.join("\n")
#  retry if detail.ok_to_retry
#  raise
#ensure
#  puts "ensure"
end

puts "OK"