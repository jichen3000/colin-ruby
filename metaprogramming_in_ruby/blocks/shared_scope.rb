def define_methods 
    shared = 0
    Kernel.send :define_method, :counter do 
        shared
    end
    Kernel.send :define_method, :inc do |x| 
        shared += x
    end 
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            define_methods
            counter.must_equal(0)
            inc(4).must_equal(4)
            counter.must_equal(4)
        end
    end
end