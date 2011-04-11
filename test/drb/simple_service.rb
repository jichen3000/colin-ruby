# A simple DRb service
require 'drb'

# start up the DRb service
# If it is nil, DRb uses the first open port.
obj = []
DRb.start_service("druby://jcbook:2222",obj)

puts "uri: "+DRb.uri.to_s
#require 'pp'
#pp obj

DRb.thread.join