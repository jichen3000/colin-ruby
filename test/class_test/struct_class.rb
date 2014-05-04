Person = Struct.new(:name)
class Person
    def get_name
        @name
    end
    def get_name1
        self.name
    end
end

colin = Person.new("cc")
p colin.get_name()
p colin.get_name1()
p Person.instance_methods
# p colin.instance_variable_get("name")