class MyModel
    def self.foo
        "foo"
    end
    def self.foo_1(arg1)
        arg1
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            method_name = 'foo'
            if MyModel.respond_to?(method_name)
                MyModel.send(method_name).must_equal(method_name)
            end
            MyModel.send("foo_1",1).must_equal(1)
        end
    end
end