# require ruby 1.9
# get method self name
def test_method
    __method__
end

def foo
    __method__
end

def plus(a,b)
    a + b
end

def plus_type1(a,b)
    a + b + 1
end

def choose_method(method_name, type_name)
    
end


if __FILE__ == $0
    require 'minitest/spec'
    require 'minitest/autorun'
    require 'testhelper'

    describe 'method' do
        it "return method name" do
            test_method.must_equal(:test_method)
        end
        it "can call method programatically" do
            foo_method = method(:foo)
            foo_method.call().must_equal(:foo)

            foo_method.owner.must_equal(Object)
            foo_method.receiver.must_equal(self)

            method(:plus).call(3,4).must_equal(7)
        end

        it "how to map using function" do
            arr = %w{a bb ccc}
            arr.map(&:length).must_equal([1, 2, 3])
        end
    end

end