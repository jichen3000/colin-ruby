begin
  1/0
rescue => e
#  puts e
  print e.backtrace.join("\n")
end
