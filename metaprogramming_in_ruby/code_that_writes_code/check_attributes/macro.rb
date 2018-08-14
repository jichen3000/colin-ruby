class Object
    def self.attr_checked(attribute, &validation)
        define_method "#{attribute}=" do |arg|
            if validation
                valid_result = validation.call(arg)
            else
                valid_result = (arg != nil)
            end
            raise RuntimeError.new('invalid attribute') if not valid_result
            instance_variable_set("@#{attribute}".to_sym,arg)
        end
        define_method "#{attribute}" do
            instance_variable_get("@#{attribute}".to_sym)
        end
    end
end

class Person
    attr_checked :age do |v|
        v >= 18
    end
end


if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        # add_checked_attribute(Person, :age) {|age| age >= 18}
        bob = Person.new
        it "normal" do
            bob.age = 20
            bob.age.must_equal(20)
        end
        it "raise when smaller" do
            # bob.age=17
            -> {bob.age=17}.must_raise(RuntimeError)
        end
        # it "raise when nil" do
        #     bob.age=nil
        #     -> {bob.age=nil}.must_raise(RuntimeError)
        # end
        # it "raise when false" do
        #     -> {bob.age=false}.must_raise(RuntimeError)
        # end
    end
end