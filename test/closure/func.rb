def func
  x = 12
  lambda {x += 1; p x}
end

proc = func
proc[]
proc[]
proc.call
  
p "ok"