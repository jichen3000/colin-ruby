def my_to_i the_str
    Integer the_str
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            [1, 2, 3].map(&:to_s).must_equal(["1", "2", "3"])
            Integer("1").must_equal(1)
            ["1", "2", "3"].map(&method(:Integer)).must_equal([1, 2, 3])
            ["1", "2", "3"].map(&method(:my_to_i)).must_equal([1, 2, 3])
            
        end
    end
end
