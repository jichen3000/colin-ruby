require 'my_rb.rb'
#require 'my_module.rb'
#include MyModule

class Log
	def initialize
	end
	def print(str)
		puts str
	end
end

#puts MyModule.constants
#puts MyModule.instance_methods
#puts MyModule::M_1
#MyModule::set_log(Log.new)
@@log = Log.new 
mc = MyClass.new
mc.print(M_1)