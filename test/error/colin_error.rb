class ColinError < StandardError
end

def get_colin_error
  raise ColinError.new("colin error")
end

begin
  get_colin_error
rescue ColinError => detail
  puts detail.message
  # 不能调用本句
#  puts detail.backtrace.join("\n")
#  retry if detail.ok_to_retry
#  raise
#ensure
#  puts "ensure"
end