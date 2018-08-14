require 'timeout'
before = Time.now
begin
  status = Timeout.timeout(5){sleep 6}
rescue Timeout::Error
  puts "I only slept for #{Time.now - before} seconds."
end

  # status = Timeout.timeout(5){sleep}
