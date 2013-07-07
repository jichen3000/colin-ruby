

class Person
    def initialize(name)
        @name = name
    end
    def name
        @name
    end
end

class MethodInterception
    def self.before(obj, method, proc)
        # proc.call
        eval_string = "
          alias_method :old_#{method}, :#{method}

          def #{method}(*args)
            puts 'going to call former method'
            puts #{proc}
            #{obj}.instance_eval(#{proc})
            #{proc}.call

            result = old_#{method}(*args)
            puts 'former method called'
            result
          end
        "
        obj.class.class_eval(eval_string)
        # p obj.class
        # p eval_string
        # p obj.methods.include?(:alias_method)
        # p obj.methods.include?(:alias)
    end
end


# def new_name(old_proc)
#     @name += "1234"
#     old_proc.call
# end

def before_name()
    @name = "123"
    p @name
end
colin = Person.new("colin")
MethodInterception.before(colin, :name, Proc.new(){before_name}) 
p colin.name


p colin.name