module MyModule1
    def my_method1; 'hello'; end
end
obj = Object.new
obj.extend(MyModule1)

class MyClass 
    extend MyModule1
end

# extend equals include in the singleton_class
module MyModule2
    def my_method2; 'hello'; end
end
class << obj
    include MyModule2
end
class MyClass
    class << self
        include MyModule2
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "extend" do
            obj.my_method1.must_equal('hello')
            MyClass.my_method1.must_equal('hello')
        end
        it "singleton class include" do
            obj.my_method2.must_equal('hello')
            MyClass.my_method2.must_equal('hello')
        end
    end
end