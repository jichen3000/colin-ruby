class A
  def puts_my
    puts "old puts my"
  end
end

class A
  def puts_my
#    self.puts_my
    puts "new puts my"
  end
end

a = A.new()
a.puts_my