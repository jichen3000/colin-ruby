def test1(*args)
  p args
  p args.join(",")
end
def test2(a1,*args)
  p args
  p args.join(",")
end

test1('jc',1)
test2('jc',1)

p "ok"