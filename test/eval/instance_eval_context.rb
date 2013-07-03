require 'test/unit/testcase'

class OtherObject
    def identify
        return "in other object"
    end
    def use_call &arg
        arg.call
    end
    def use_instance_eval &arg
        instance_eval &arg
    end
end
class StaticContext < Test::Unit::TestCase
    def identify
        return "in static context"
    end
    def test_demo
        o = OtherObject.new
        assert_equal "in static context", o.use_call {p self, identify}
        assert_equal "in other object", o.use_instance_eval {p self, identify}
    end 
end

