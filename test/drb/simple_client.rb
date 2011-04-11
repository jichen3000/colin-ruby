# A simple DRb client
require 'drb'
require 'pp'

DRb.start_service
remote_array = DRbObject.new(nil, "druby://jcbook:2222")
#pp remote_array
puts "remote_array.size: #{remote_array.size}"
pp remote_array
remote_array << 1
puts "remote_array.size: #{remote_array.size}"
