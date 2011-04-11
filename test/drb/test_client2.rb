require 'drb'

DRb.start_service
remote_obj = DRbObject.new(nil,"druby://jcbook:3333")

remote_obj.test_do(true,"client 2")

#puts "client 2 end.."