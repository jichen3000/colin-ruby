module Swingable
    @msg1 = '111'
    def self.puts_msg
        puts @msg1
    end
    def self.msg1=(str)
        @msg1 = str
    end
    @@class_msg = '111'
    def self.class_msg=(str)
        @@class_msg = str
    end
    def self.included(base)
        base.extend(ClassMethods)
    end


    def instance_swing
        puts 'Did an instance swing!'
        # puts msg1
    end

    module ClassMethods
        def static_swing
            puts 'Did a static swing!'
            # puts @@class_msg
        end
    end
end

class BaseballBat
    @msg = "BaseballBat @"
    @@msg = "BaseballBat"
    include Swingable
    def self.put_msg
        puts @@msg
    end
    def self.set_module_msg(str)
        Swingable.msg1 = str
    end
    def self.set_module_class_msg(str)
        Swingable.class_msg = str
    end
end

BaseballBat.static_swing
BaseballBat.new.instance_swing
Swingable.puts_msg
# BaseballBat.puts_msg
BaseballBat.set_module_msg("3333")
Swingable.puts_msg
