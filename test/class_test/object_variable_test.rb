class TestClass
	CV1 = 'cv1'
	def initialize
		@v1 = 1
		@v2 = 2
	end
end

tc = TestClass.new
require 'pp'
pp tc.instance_variables
tc.instance_variables.each do |item|
	puts item + " : " +tc.instance_variable_get(item).to_s
end