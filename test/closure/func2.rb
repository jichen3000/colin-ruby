def func1
  x = 100
  lambda{|y| x+=y; p x}
end

def func2
  x = 100
  lambda do |y|
    x*=y
    p x
  end
end

def get_proc(type)
  case type
  when '+'
    func1
  when '*'
    func2
  else
    raise "unsupport type!#{type}"
  end
end
  
proc = get_proc('+')
proc[2]
proc.call(5)
proc = get_proc('*')
proc[2]
proc.call(5)
p "ok"