class A
end

# instace_eval will in the context of current instance
a = A.new
a.instance_eval do
  self  # => a
  # current class => a's singleton class
  def method1
    puts 'this is a singleton method of instance a'
  end
end

a.method1
#=> this is a singleton method of instance a

b = A.new
# b.method1
#=>NoMethodError: undefined method `method1' for #<A:0x10043ff70>

A.instance_eval do
  self  # => A
  # current class => A's singleton class
  def method1
    puts 'this is a singleton method of class A'
  end
end

A.method1
#=> this is a singleton method of class A

# class_eval
a = A.new
# a.method1
#=> NoMethodError: undefined method `method1' for #<A:0x10043ff70>

A.class_eval do
  self  # => A
  # current class => A
  def method1
    puts 'this is a instance method of class A'
  end
end

a.method1
#=> this is a instance method of class A