require 'date'

Event = Struct.new(:name, :date)

e = Event.new("jc")
p e
e.date = Date.today
p e

e.freeze
e.name[0] = "2"

p e
# p e.has_attributes?

# it will give the different class
class Event
    def p_name
        p @name
    end
    def p_self_name
        p self.name
    end
end

e.p_name

Event1 = Struct.new(:name, :date)
# add method
Event1.class_eval do
    def at_name
        @name
    end
    def self_name
        self.name
    end
end
p "e1"
e1 = Event1.new("jc")
p e1.name
p e1.at_name
p e1.self_name

class Event2
    attr_reader :name
    def initialize(name)
        @name = name
    end
    def at_name
        @name
    end
    def self_name
        self.name
    end
end
p "e2"
e2 = Event2.new("jc")
p e2.name
p e2.at_name
p e2.self_name
