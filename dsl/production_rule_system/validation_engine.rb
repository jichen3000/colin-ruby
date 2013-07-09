# It's from DSL chapter 50

class ValidationEngine
    def initialize()
        @rules = []
    end
    def run(obj)
        @rules.map {|r| r.check(obj)}
    end
    def add_rule(rule)
        @rules.push(rule)
        self
    end
end

class ValidationRule
    def initialize(proc, msg)
        @msg = msg
        @proc = proc
    end
    def check(obj)
        @proc.call(obj) ? @msg+" is OK." : @msg+" is failed!!!"

    end
end

Person = Struct.new(:name, :university, :nationality, :annual_income)

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'

    describe ValidationEngine do
        it "can validate" do
            engine = ValidationEngine.new
            engine.add_rule(ValidationRule.new(lambda {|p| p.nationality != nil},
                "Person's nationality check"))

            colin = Person.new("Colin")
            engine.run(colin).must_equal(
                ["Person's nationality check is failed!!!"])
            colin.nationality = "China"
            engine.run(colin).must_equal(
                ["Person's nationality check is OK."])
        end
    end
end
