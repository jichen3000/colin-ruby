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
  # use ctrl+d to jump next binding.pry
  require 'pry';binding.pry
  puts detail.message
  require 'pry';binding.pry
  
 retry if detail.ok_to_retry
ensure
 puts "ensure"
end