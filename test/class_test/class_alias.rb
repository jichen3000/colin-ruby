class A
  
end
class AB < A
  
end
class AC < A
  def self.p
    p "AC"
  end
  def mysend(method_name)
    
  end
end

alias AC A
A.p 
