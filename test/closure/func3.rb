def func_add
  lambda{|x,y| x+y}
end
def func_dual
  lambda{|x,y| x*y}
end
def func1
  x = 100
  lambda{|y,func| x=func[x,y]; p x}
end

proc = func1
proc[2,func_add]
proc = func1
proc[2,func_dual]

p "ok"

