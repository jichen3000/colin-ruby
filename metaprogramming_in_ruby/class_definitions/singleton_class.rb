# An object has its own special, hidden class. singleton class
obj = Object.new
obj_singleton_class = class << obj 
    self
end

def obj.my_method
    puts __method__
end

class C
    def a_method
        'C#a_method()'
    end 
end
class D < C; end

obj_d = D.new
class << obj_d
    def a_singleton_method
        'obj#a_singleton_method()'
    end 
end

class C
    class << self
        def a_class_method 
            'C.a_class_method()'
        end 
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            obj_singleton_class.class.must_equal(Class)

            # other way
            obj.singleton_class.class.must_equal(Class)

            obj_singleton_class.instance_methods.grep(/my_/).must_equal([:my_method])
            obj.singleton_class.instance_methods.grep(/my_/).must_equal([:my_method])
        end

        it "" do
            obj_d.singleton_class.superclass.must_equal(D)

            D.singleton_class.superclass.must_equal(C.singleton_class)
        end
    end
end

