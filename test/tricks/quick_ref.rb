# http://www.zenspider.com/Languages/Ruby/QuickRef.html#4

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "QuickRef" do
        it "for array" do
            arr = %w{a b c #{1+2}}
            arr.must_equal(["a", "b", "c", "\#{1+2}"])
            
            arr = %W{a b c #{1+2}}
            arr.must_equal(["a", "b", "c", "3"])

            %w{a b c}.map(&:to_sym).must_equal([:a, :b, :c])
        end
    end
end