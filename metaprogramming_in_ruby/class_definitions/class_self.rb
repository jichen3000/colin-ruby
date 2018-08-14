my_class = class MyClass
    self
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            my_class.pt
            my_class.class.pt
        end
    end
end