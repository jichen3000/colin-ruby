# http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Method_Calls

def gen_times(factor)
  return Proc.new {|n| n*factor }
end

times3 = gen_times(3)      # 'factor' is replaced with 3
times5 = gen_times(5)

p times3.call(12)               #=> 36
p times5.call(5)                #=> 25
p times3.call(times5.call(4))   #=> 60

def foo (a, b)
  a.call(b)
end

putser = Proc.new {|x| puts x}
foo(putser, 34)
putser1 = lambda {|x| puts x}
foo(putser1, 35)

# Actually, there are two slight differences between lambda and Proc.new. First, argument checking. 
# The Ruby documentation for lambda states: Equivalent to Proc.new, 
# except the resulting Proc objects check the number of parameters passed when called. 
# Here is an example to demonstrate this:
pnew = Proc.new {|x, y| puts x + y}
lamb = lambda {|x, y| puts x + y}

# works fine, printing 6
pnew.call(2, 4, 11)

# throws an ArgumentError
# lamb.call(2, 4, 11)

# Second, there is a difference in the way returns are handled from the Proc. 
# A return from Proc.new returns from the enclosing method 
# (acting just like a return from a block, more on this later):
def try_ret_procnew
  ret = Proc.new { return "Baaam" }
  ret.call
  "This is not reached"
end
# prints "Baaam"
puts try_ret_procnew

# While return from lambda acts more conventionally, returning to its caller:
def try_ret_lambda
  ret = lambda { return "Baaam" }
  ret.call
  "This is printed"
end
# prints "This is printed"
puts try_ret_lambda

# With this in light, I would recommend using lambda instead of Proc.new, 
# unless the behavior of the latter is strictly required. 
# In addition to being a whopping two characters shorter, 
# its behavior is less surprising.


say = lambda {|something| puts something}
say.call("Hello")
# same effect
say["Hello"]
say_proc = Proc.new {|something| puts something}
say_proc["hello"]



