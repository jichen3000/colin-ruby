proc = lambda{|x| p x}
[1,2,3].each(&proc)
p "ok"