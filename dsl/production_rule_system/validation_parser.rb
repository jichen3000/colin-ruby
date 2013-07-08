$:.unshift File.dirname(__FILE__)
require 'validation_engine'

class ValidationBuilder
    class << self
        def build
            validate("Annual Income is present").with.annual_income.not_nil
            validate("Annual Income is larger than").with.annual_income.larger_than(50)
        end
        def validate(msg)
            @@msg = msg
            self
        end
        def not_nil()
            proc = lambda {|p| p[@@attribute_name] != nil}
            @@engine ||= ValidationEngine.new
            @@engine.add_rule(ValidationRule.new(proc, @@msg))
            @@engine
        end
        def larger_than(count)
            proc = lambda {|p| p[@@attribute_name] and p[@@attribute_name] > count}
            @@engine ||= ValidationEngine.new
            @@engine.add_rule(ValidationRule.new(proc, @@msg))
            @@engine
        end
        def with
            @@with_flag = true
            self
        end
        def method_missing(name)
            if @@with_flag
                @@attribute_name = name
                @@with_flag = false
                return self
            else
                super
            end
        end
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    describe "ValidationBuilder" do
        it "can parser" do 
            require "pp"
            colin = Person.new("Colin")
            engine =  ValidationBuilder.build
            engine.run(colin).must_equal(
                ["Annual Income is present is failed!!!",
                 "Annual Income is larger than is failed!!!"])

            colin.annual_income = 25
            engine.run(colin).must_equal(
                ["Annual Income is present is OK.",
                 "Annual Income is larger than is failed!!!"])
            
            colin.annual_income = 100
            engine.run(colin).must_equal(
                ["Annual Income is present is OK.", 
                 "Annual Income is larger than is OK."])

        end
    end
end

