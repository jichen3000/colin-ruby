begin
  1 / 0
rescue Exception => e
    # puts e.message
    puts e.inspect + "\n" + e.backtrace.join("\n")
    # puts e.inspect + "\n" + e.backtrace.first
    # puts $!.inspect, $@
    # puts e
end
