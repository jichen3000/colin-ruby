module WarnMethod
  def warn_method
    warn "don't use!"
  end
end
class Colin
  module Inside
    def a_10g
      "a_10g"
    end
    def a_9i
      "a_9i"
    end
  end
  module SelfInside
    def b_10g
      "self.b_10g"
    end
    def b_9i
      "self.b_9i"
    end
  end
  class << self
    def alias_m2
      extend SelfInside
      alias b b_9i
    end
    p self.class.singleton_methods
  end
  def self.alias_m(type)
    include Inside if not self.include?(Inside)
    include WarnMethod if not self.include?(WarnMethod)
    extend SelfInside
    p self.singleton_methods
    if type == "a_9i"
      alias a a_9i
#      alias b b_9i
    else  
      alias a a_10g
#      alias b b_10g
    end
    alias a_9i warn_method
    alias a_10g warn_method
#    alias b_9i warn_method
#    alias b_10g warn_method
  end
  def initialize(type)
    self.class.alias_m(type)
  end
  def c
    "c"
  end
end

#Colin.alias_m("a")
#Colin.alias_m("a_10g")
c = Colin.new("a_10g")
Colin.alias_m2
puts "That is legal use!"
puts c.a
puts Colin.b
puts "That is not legal use!"
puts c.a_10g
#puts Colin.b_9i
p "ok"