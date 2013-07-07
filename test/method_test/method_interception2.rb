
class Person
    def initialize(name)
        @name = name
    end
    def name
        @name
    end
    @@list = []
    def self.build
        p "list"
    end
end


def before_name()
    @name = "123"
    # p @name
end
colin = Person.new("colin")

def before_method(obj, method, proc)
    obj.class.class_eval do 
        alias_method :cc_name, :name
        def name
            @name += "222"
        end
        class << self
            alias_method :cc_build, :build
            def build
                p "new"
            end
        end
    end
end

p "new"

before_method(colin, nil, lambda{before_name})
p colin.cc_name
p colin.name

Person.cc_build
Person.build