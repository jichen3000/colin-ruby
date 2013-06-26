def func(x)
  lambda {x += 1; p x}
end

proc = func(12)
proc[]
proc[]
proc.call
  
p "ok"