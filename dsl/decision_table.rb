# from DSL chapter 48

# Condition = Struct.new(:description, :test_type)
class Condition
    def initialize(description, &test_block)
        @description = description
        @test_block = test_block
    end
    def test?
        @test_block.call == "jc"
    end
    
end
class DecisionTable
    def initialize
        @conditions = []
        @colums = []
    end
    def add_condition(description, &test_block)
        conditions.push(Condition.new(description, test_type))
    end
end



# class Person
#     def myname
#         "jc"
#     end
# end
# a = Condition.new("j"){ Person.new.myname}
# p a.test?