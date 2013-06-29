# http://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Method_Calls


# Blocks, as I see them, are unborn Procs. Blocks are the larval, Procs are the insects. 
# A block does not live on its own - it prepares the code for when it will actually become alive, 
# and only when it is bound and converted to a Proc, it starts living:

# a naked block can't live in Ruby
# this is a compilation error !
# {puts "hello"}

# now it's alive, having been converted
# to a Proc !
pr = lambda {puts "hello"}

pr.call

# Whenever a block is appended to a method call, 
# Ruby automatically converts it to a Proc object but one without an explicit name. 
# The method, however, has a way to access this Proc, by means of the yield statement. 
# See the following example for clarification:

def do_twice
  yield 
  yield
end

do_twice {puts "Hola"}

# The method do_twice is defined and called with an attached block. 
# Although the method did not explicitly ask for the block in its arguments list, 
# the yield can call the block. 
# This can be implemented in a more explicit way using a Proc argument:
def do_twice(what)
  what.call
  what.call
end

do_twice lambda {puts "Hola"}

# Remember how I said that although an attached block is converted to a Proc under the hood, 
# it is not accessible as a Proc from inside the method ? 
# Well, if an ampersand is prepended to the last argument in the argument list of a method, 
# the block attached to this method is converted to a Proc object and gets assigned to that last argument:
def contrived(a, &f)
  # the block can be accessed through f
  f.call(a)

  # but yield also works !
  yield(a)
end

# this works
contrived(25) {|x| puts x}

# this raises ArgumentError, because &f 
# isn't really an argument - it's only there 
# to convert a block
# contrived(25, lambda {|x| puts x})

# Another (IMHO far more efficacious) use of the ampersand is the other-way conversion - 
# converting a Proc into a block. This is very useful because many of Ruby’s great built-ins, 
# and especially the iterators, expect to receive a block as an argument, 
# and sometimes it’s much more convenient to pass them a Proc. 
# The following example is taken right from the excellent “Programming Ruby” book by the pragmatic programmers:
print "(t)imes or (p)lus: "
# times = gets
times ="t"
print "number: "
# number = Integer(gets)
number = Integer("5")
if times =~ /^t/
  calc = lambda {|n| n*number }
else
  calc = lambda {|n| n+number }
end
puts((1..10).collect(&calc).join(", "))


class Symbol

  # A generalized conversion of a method name
  # to a proc that runs this method.
  #
  def to_proc
      lambda {|x, *args| x.send(self, *args)}
  end

end
# Voila !
words = %w(Jane, aara, multiko)
upcase_words = words.map(&:upcase)
p upcase_words



a = 'b'
def a.some_method
    'within a singleton method just for a'
end
a.define_singleton_method(:some_method) {
    'within a block method'
}
