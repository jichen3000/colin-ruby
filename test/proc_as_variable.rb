class Person
    attr_accessor :name, :age, :father
    def initialize(name, age=18)
        @name = name
        @age = age
    end
    def old?
        @age > 60
    end
end

def invoke_block(proc)
    old_one = Person.new("John", 31)
    old_one.father = Person.new("Old John", 61)
    old_one.instance_eval(&proc)

end

def gen_block_by_block(&block)
    # old_one.instance_eval(&block)
    lambda {|person| person.instance_eval(&block)}

end

# cannot use lambda, since it will report the worng number of parameters.
old_proc = Proc.new {father.old?} 
p old_proc.arity
p invoke_block(old_proc)

old_one = Person.new("John", 31)
old_one.father = Person.new("Old John", 59)
new_proc = gen_block_by_block(&old_proc)
p new_proc.call(old_one)