class Greeting
    def initialize(text)
        @text = text
    end
    def welcome 
        @text
    end 
end


if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            my_object = Greeting.new("hello")
            my_object.class.must_equal(Greeting)
            my_object.class.instance_methods(false).must_equal([:welcome])
            my_object.instance_variables.must_equal([:@text])
            my_object.instance_variable_get(:@text).must_equal("hello")
            my_object.instance_variable_get("@text").must_equal("hello")
            my_object.instance_variable_get(:@tt).must_equal(nil)
        end
    end
end