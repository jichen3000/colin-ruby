def my_method
    x = "Goodbye"
    yield("cruel")
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            x = "Hello"
            my_method {|y| "#{x}, #{y} world"}.must_equal(
                "Hello, cruel world")
        end
    end
end