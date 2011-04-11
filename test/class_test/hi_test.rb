class A
	attr :aa, :ab
	def initialize(aa,ab)
		@aa = aa
		@ab = ab
	end
	def p_a
		puts "p_a"
	end
end

class B < A
	attr :ba
	def initialize(aa,ab,ba)
	  super(aa,ab)
#		@aa = aa
#		@ab = ab
		@ba = ba
	end
end

b = B.new(1,2,3)
b.p_a
p b.ba