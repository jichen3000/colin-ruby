str = "just a regular string"
def str.title? 
    self.upcase == self
end
if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            str.title?.must_equal(false)
            str.methods.grep(/title?/).include?(:title?).must_equal(true)
            str.singleton_methods.include?(:title?).must_equal(true)
        end
    end
end