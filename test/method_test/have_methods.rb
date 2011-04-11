# object.

module M
  def self.included(c)
    c.extend(SM)
  end
  module SM
    def puts_sm(*arg)
      puts "sm"
    end
  end
  def puts_m
    puts "m"    
  end
end
class A
#  include M
  self.extend(M)
  def puts_aaa
    puts "a"
  end  
#  puts_sm :ddd
end
p A.singleton_methods
a = A.new
p a.public_methods - A.class.public_methods