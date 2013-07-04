module Swingable

    def self.included(base)
        base.extend(ClassMethods)
    end


    def instance_swing
        puts 'Did an instance swing!'
    end

    module ClassMethods
        def static_swing
            puts 'Did a static swing!'
        end
    end
end

class BaseballBat
   include Swingable
end

BaseballBat.static_swing
BaseballBat.new.instance_swing