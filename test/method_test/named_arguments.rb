def mm(value:nil, is_leaf:true)
    {value:value, is_leaf:is_leaf}
end

def mm2(value:nil, is_leaf:true)
    {value:value, is_leaf:is_leaf}
end

if __FILE__ == $0
    require 'testhelper'
    require 'minitest/spec'
    require 'minitest/autorun'

    describe "named arguments" do
        it "can pass named arguments directly" do
            result = mm()
            mm2(result).must_equal({value:nil, is_leaf:true})

            the_arguments = {value:1, is_leaf:false}
            result = mm(the_arguments)
            mm2(result).must_equal(the_arguments)
        end
    end
end
