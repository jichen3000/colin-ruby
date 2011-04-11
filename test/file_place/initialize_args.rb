class InputArg
  def initialize(name,value=nil,desc=nil,type=String.class,default_value=nil)
    self.name=name
    self.value=value
    self.desc=desc
    self.type=type
    self.default_value=default_value
  end
end

class InitializeArgs
  
end
