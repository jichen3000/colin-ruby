class Person
end

def add_checked_attribute(klass, attribute)
    codes = %Q{
        class #{klass}
            def #{attribute}=(arg)
                if arg==nil or arg == false
                    raise RuntimeError.new('invalid attribute')
                end
                @#{attribute}=arg
            end
            def #{attribute}
                @#{attribute}
            end
        end
    }
    eval(codes)
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        add_checked_attribute(Person, :age)
        bob = Person.new
        it "normal" do
            bob.age = 20
            bob.age.must_equal(20)
        end
        it "raise when nil" do
            -> {bob.age=nil}.must_raise(RuntimeError)
        end
        it "raise when false" do
            -> {bob.age=false}.must_raise(RuntimeError)
        end
    end
end