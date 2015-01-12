module TestA
    def self.included(base)
        base.extend(ClassMethods)
    end
    # def self.puts_me()
    #     puts("TestA")
    # end
    module ClassMethods
        def puts_me()
            puts("ClassMethods::TestA")
        end
    end
end

class TestB
    include TestA
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "TestB" do
        it "function" do
            TestB.puts_me
            TestA.puts_me
        end
    end
end