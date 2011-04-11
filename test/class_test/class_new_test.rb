require 'pp'

class TestNew
  attr_reader :str, :a, :b, :v1
  def initialize(v1,*arg)
  	@v1 = v1
    if arg.size == 1
      set_attrs1(arg[0])
    elsif arg.size == 2
      set_attrs2(arg[0],arg[1])
    end
  end
#  def initialize(str)
#    @str = str
#  end
#  def initialize(a,b)
#    @a = a
#    @b = b
#  end
  def set_attrs1(str)
    @str = str
  end
  def set_attrs2(a,b)
    @a = a
    @b = b
  end
end
v1 = 'mm'
str = 'jc'
tn1 = TestNew.new(v1,str)
a = 1
b = 2
tn2 = TestNew.new(v1,a,b)
pp tn1
pp tn2