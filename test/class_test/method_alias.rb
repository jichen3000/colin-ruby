class T
  def self.change(condition)
    if condition
      alias initialize a
    else
      alias initialize b
    end
  end
  def a
    puts "a"
  end
  
  def b
    puts "b"
  end
end

T.change(false)
#T.change(true)
T.new