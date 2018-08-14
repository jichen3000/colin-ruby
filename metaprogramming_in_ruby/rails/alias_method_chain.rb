module Greetings 
    def greet
        "hello"
    end 
end

class MyClassSimple
    include Greetings
end

class MyClassAlias 
    include Greetings
    def greet_with_enthusiasm
        "Hey, #{greet_without_enthusiasm}!"
    end
    alias_method :greet_without_enthusiasm, :greet
    alias_method :greet, :greet_with_enthusiasm
end

# the best pratice
module EnthusiasticGreetings 
    include Greetings
    def greet
        "Hey, #{super}!"
    end 
end
class MyClass
    include EnthusiasticGreetings
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
           MyClassSimple.new.greet.must_equal("hello") 

           mca = MyClassAlias.new
           mca.greet.must_equal("Hey, hello!")
           mca.greet_with_enthusiasm.must_equal("Hey, hello!")
           mca.greet_without_enthusiasm.must_equal("hello")

           mc = MyClass.new 
           MyClass.ancestors[0..2].must_equal(
                [MyClass, EnthusiasticGreetings, Greetings])
           MyClass.new.greet.must_equal("Hey, hello!")
        end
    end
end