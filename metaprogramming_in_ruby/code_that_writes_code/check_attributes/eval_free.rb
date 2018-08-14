class Person
end

def add_checked_attribute(klass, attribute)
    klass.class_eval do
        define_method "#{attribute}=" do |arg|
            raise RuntimeError.new('invalid attribute') unless arg
            instance_variable_set("@#{attribute}".to_sym,arg)
        end
        define_method "#{attribute}" do
            instance_variable_get("@#{attribute}".to_sym)
        end
    end
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