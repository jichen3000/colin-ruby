class JcTest
  def self.my_puts
    puts "my"
  end
end

JcTest.my_puts
eval("JcTest").my_puts
class String
  def to_class
    eval(self)
  end
end
"JcTest".to_class.my_puts
p "ok"

