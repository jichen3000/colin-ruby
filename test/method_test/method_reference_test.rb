class A
	def f_a(other)
		puts "f_a: #{other}"
	end
	def A.f_b(other)
		puts "f_b: #{other}"
	end
end
str = "jc"
a = A.new
f_a = a.method(:f_a)
f_a.call(str)
f_b = A.method(:f_b)
f_b.call(str)