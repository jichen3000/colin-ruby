def real(&block)
    result = [ "real" ]
    if block
        result << yield
    end
    result
end
def some(&block)
    result = [ "some" ]
    result << real {yield}
    result
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "block" do
        it "function" do
            result = some { 3 }
            result.pt
        end
    end
end