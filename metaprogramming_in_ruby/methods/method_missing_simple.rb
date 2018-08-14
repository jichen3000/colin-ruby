# in python using __getattr__
# http://stackoverflow.com/questions/6704151/python-equivalent-of-rubys-method-missing
class Colin
    def self.method_missing(method_name, *args, &block)
        # if cannot match, just call super_class.method_missing
        super if not method_name.to_s.match(/^is_(\w+)/)
        [method_name] + args
    end
    def self.respond_to_missing?(method_name, include_private = false)
        return super if not method_name.to_s.match(/^is_(\w+)/)
        true
    end

end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "method_missing" do
            Colin.is_mm("jc",22, 33).must_equal([:is_mm, "jc", 22, 33])
            # error = lambda {Colin.mm()}.must_raise(NoMethodError)
            error = -> {Colin.mm()}.must_raise(NoMethodError)
            error.message.must_equal("undefined method `mm' for Colin:Class")
        end
        it "respond_to_missing" do
            Colin.respond_to?(:is_mm).must_equal(true)
            Colin.respond_to?(:mm).must_equal(false)
        end
    end
end
# p Colin.is_mm("jc",22, 33)
# Colin.mm()