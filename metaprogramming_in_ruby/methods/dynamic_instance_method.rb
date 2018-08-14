class One
    attr_accessor :name
    def initialize(name)
        @name = name
    end
end
class MyClass
    def self.create_one(name)
        one = One.new(name)
        # one.define_singleton_method("recreate") do |new_name|
        #     one = One.new(new_name)
        #     return one
        # end
        def one.recreate(new_name)
            one = One.new(new_name)
            # self = one
            one
        end
        one
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            the_one = MyClass.create_one("first")
            the_one.name.must_equal("first")
            new_one = the_one.recreate("second")
            new_one.name.pt
            the_one.name.pt
        end
    end
end