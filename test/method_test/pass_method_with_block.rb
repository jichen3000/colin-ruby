# Show how to pass a method
# the other http://stackoverflow.com/questions/522720/passing-a-method-as-a-parameter-in-ruby

Condition = Struct.new(:description, :test_type)
Condition.class_eval do
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
    def add_condition(description, test_type)
        conditions.push(Condition.new(description, test_type))
    end
end

class Person
    def initialize(name)
        @name = name
    end
    def myname
        @name
    end
end
a = Condition.new("j"){ Person.new("jc").myname}
p a.test?

# multi blocks
def jj(str, proc, &block)
    puts str
    proc.call
    block.call
end
jj("1",Proc.new {puts "block1"}) {puts "block2"}
