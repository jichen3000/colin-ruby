def func
  x = 10
  yield(x)
end

func {|x| puts x}
  
p "ok"
#funcs