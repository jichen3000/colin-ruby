require 'pp'

class TestClass
	attr_accessor :v1, :v2
	def initialize(str)
		@v1 = str
		@v2 = nil
	end
	def init_read
		@v2 = @v1
	end
end

arr = ['jc1','mm2','dd3']
pp arr
brr = arr.map {|x| x+"j"}
p brr
arr.map!{|item| x=TestClass.new(item);x.init_read;x}
pp arr

item0 = arr[0]
item2 = arr[2]
brr=[item0,item2]
item2.v1 = '001'
arr.map{|i| pp(i)}
brr.map{|i| pp(i)}
