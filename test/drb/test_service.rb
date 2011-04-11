require 'drb'
require 'pp'

class TestService
	def initialize()
		@count = 0
		@is_doing = false
	end
	def test_do(is_remote=false, client_name = nil)
		return if @is_doing
		@is_doing = true
		if is_remote
			puts "This is remote!!"
			puts "client_name : #{client_name}"
		else
			puts "This is local!"
		end
		puts "Do start..."
		puts "NO : #{@count}"
		sleep(10)
		puts "Do end."
		@count += 1
		@is_doing = false
	end
end

obj = TestService.new
DRb.start_service("druby://jcbook:3333",obj)
#DRb.thread.run

#puts "while start......"
#i = 0
#while i < 10
#	obj.test_do
#	i += 1
#end 
puts "Service start at #{DRb.uri}"
DRb.thread.join
