class Person
    attr_reader :name
    def initialize &block
        # using yield, would not have affection.
        instance_eval(&block)
    end
end

colin = Person.new {@name="colin"}
p colin.name

