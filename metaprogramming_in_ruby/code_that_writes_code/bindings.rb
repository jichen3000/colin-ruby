class MyClass
    def my_method
        @x = 1
        binding
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "binding" do
            b = MyClass.new.my_method
            eval("@x",b).must_equal(1)
            b.eval("@x").must_equal(1)
            require "pry"; binding.pry
        end
        it "toplevel" do
            TOPLEVEL_BINDING.eval("self").to_s.must_equal("main")
        end
    end
end