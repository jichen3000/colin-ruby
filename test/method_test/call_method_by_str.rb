class Colin
    def method_missing(method_name, *args, &block)
        # if cannot match, just call super_class.method_missing
        # super if not method_name.to_s.match(/^is_(\w+)/)
        [method_name] + args
    end
    def my_mm(arg1)
        arg1
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            Colin.new.send(:mm, 123).must_equal([:mm, 123])
            Colin.new.send("mm", 123).must_equal([:mm, 123])

            mm_method = Colin.new.method("my_mm")
            mm_method.call(123).must_equal(123)
        end
    end
end