class Test
  attr_reader :a1, :arr
  def initialize
    @a1 = "a1"
    @arr = []
    @arr << "ksdjf"
  end
end


t = Test.new
@aa2 = "aa2"
@int = 3
def setup_str(str)
  str = "setup"
  str
end
def setup_int(tint)
  tint = 456
  tint
end
def setup_arr(tarr)
  tarr << "123"
end
p @aa2
p setup_str(@aa2)
p @aa2
p t.a1
p setup_str(t.a1)
p t.a1
p @int
p setup_int(@int)
p @int
p t.arr
p setup_arr(t.arr)
p t.arr

p "ok"