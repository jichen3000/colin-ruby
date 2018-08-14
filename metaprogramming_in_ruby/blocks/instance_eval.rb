class MyClass 
    def initialize
        @v = 1
    end 
end

obj = MyClass.new
obj.instance_eval do
    self # => #<MyClass:0x3340dc @v=1> 
    @v # => 1
end