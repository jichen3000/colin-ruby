class Atest
  def self.set_put
    alias put2 put1
  end
#  def set_put2
#    alias put4 put3
#  end
  def put1
    puts "put1"
  end
  def put2
    puts "put2"
  end
  class << self
    def put3
      puts "self.put3"
    end
    def put4
      puts "self.put4"
    end
#    alias put4 put3
    def set_put2
      alias put4 put3
    end
  end
end

a = Atest.new
a.put1
a.put2

Atest.set_put
a.put1
a.put2

#Atest.set_put2
Atest.put4