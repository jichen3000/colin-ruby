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

# just for ruby 2
def meth(id, options: "options", scope: "scope")
  puts options
  puts scope
end

meth 1, scope: "meh"
# for ruby 2.0
# => "options"
meth 1, options: "jcc"
puts RUBY_VERSION