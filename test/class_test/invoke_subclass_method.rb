class A
    def some()
        subsome
    end
end

class AA < A
    def subsome
        "sub"
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            aa = AA.new()
            aa.some().pt
        end
    end
end