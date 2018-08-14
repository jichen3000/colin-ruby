def double(callable_object) 
    callable_object.call * 2
end
def another_double
    p = Proc.new { return 10 }
    result = p.call # return from here
    return result * 2 # unreachable code!
end
if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "for return" do
            # lambdas return was more normal
            # proc return from the place where it was defined
            l = lambda { return 10 }
            double(l).must_equal(20)

            another_double.must_equal(10)

        end
        it "for arguments" do
            # lambda has less tolerant than porcs
            m = lambda {|x, y| [x,y]}
            m.arity.must_equal(2)
            error = -> {m.call(1)}.must_raise(ArgumentError)
            error.message.must_equal("wrong number of arguments (1 for 2)")

            n = Proc.new {|x, y| [x,y]}
            n.arity.must_equal(2)
            n.call(1).must_equal([1, nil])
            n.call(1,2,3).must_equal([1, 2])
        end
    end
end