class MM
    attr_reader :aa
    def initialize(aa)
        @aa = aa
    end
    def get_a
        aa.get_a
    end
end
class AA
    attr_reader :variables
    def initialize()
        @variables = {}
    end
    def set_variable(class_name, variable_name)
        # @variables[variable_name] = class_name.new(self)
        self.define_singleton_method(variable_name,
            proc{ class_name.new(self) })
    end
    def get_a()
        "a"
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            aa = AA.new()
            aa.set_variable(MM, "mm")
            aa.mm.get_a.must_equal("a")
            # aa.bb.pt
        end
    end
end