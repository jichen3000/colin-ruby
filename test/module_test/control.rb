module Control
  def runned?(name)
    @control_hash[name]
  end
  def set_runned(name)
    @control_hash[name] = true
  end
  def p1
    p "one"
  end
  def p2
    if @@p2_runed == nil 
      p "two"
      @@p2_runed = true
    end
  end
end
class C2
  @@p2_runed = nil
  def self.p2
    if @@p2_runed == nil 
      p "two"
      @@p2_runed = true
    end
  end
end

class Test
  include Control
  def initialize
    @control_hash = {}
  end
  def test1
    if not @control_hash[:p1]
      p1
      @control_hash[:p1] = true
    end
  end
  def test2
    p2
  end
  def c2_p2
    C2.p2
  end
end


t = Test.new
t.test1
p "1"
t.test1
t.test1
#t.test2
#p "2"
#t.test2
#t.test2
t.c2_p2
p "3"
t.c2_p2
t.c2_p2
p "ok"