class ATest
  def self.puts_a
    puts "a"    
  end
  def puts_my
    puts self.class.name    
  end
end
class ATest_One < ATest
#  alias :puts_a :puts_old 
  def self.puts_a
    puts "b"
    super
  end  
end
def create_class(class_name) 
  eval %{
    class BTest < ATest
    end
  }
end

create_class(:BTest)
b = BTest.new
b.puts_my

ATest_One.puts_a
p "ok"