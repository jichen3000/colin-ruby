class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end
class Colin
    def initialize()
        set_all_variables(Helper)
    end
    def set_all_variables(the_module)
        the_module.constants.each do |class_name|
            # class_name.pt
            set_variable(the_module.const_get(class_name),
                    class_name.to_s.underscore)
        end
    end
    def set_variable(klass, variable_name)
        # @variables[variable_name] = klass.new(self)
        self.define_singleton_method(variable_name,
            proc do 
                value = self.instance_variable_get("@"+variable_name)
                if value == nil
                    value = klass.new(self) 
                    self.instance_variable_set("@"+variable_name, value)
                end
                value
            end)
    end
end
module Helper
    class Vdom
        def initialize(value)
            @value = value
        end
    end
    class Iperf
        attr_reader :result
        def initialize(value)
            @value = value
            @result = nil
        end
        def set_result(result)
            @result = result
        end
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            colin = Colin.new()
            colin.iperf.result.must_equal(nil)
            colin.iperf.set_result("mm")
            colin.iperf.result.must_equal("mm")
        end
    end
end