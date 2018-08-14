class Colin
    def initialize(value)
        @value = value
    end
    def value
        @value
    end
end
def return_two()
    ['1','2']
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            colin = Colin.new(1)
            value_method = colin.method(:value)
            value_method.call.must_equal(1)
            a,b = return_two
            [a,b].pt
        end
    end
end