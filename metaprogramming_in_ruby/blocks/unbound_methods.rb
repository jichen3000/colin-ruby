module MyModule 
    def my_method
        42
    end 
end
class MyClass
    include MyModule
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "unbound method" do
            unbound_method = MyModule.instance_method(:my_method)
            unbound_method.class.must_equal(UnboundMethod)

            my = MyClass.new.method(:my_method)
            my.class.must_equal(Method)
            un_my = my.unbind
            un_my.class.must_equal(UnboundMethod)
        end

        it "give the unbound method to object" do
            unbound_method = MyModule.instance_method(:my_method)
            String.class_eval do 
                define_method :another, unbound_method
            end
            "".another.must_equal(42)
        end
    end
end