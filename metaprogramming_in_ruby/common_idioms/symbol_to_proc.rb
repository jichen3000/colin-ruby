# class Symbol 
#     def to_proc
#         Proc.new {|x| x.send(self) }
#     end 
# end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            names = ['bob', 'bill', 'heather']
            names.map {|name| name.capitalize }.must_equal(["Bob", "Bill", "Heather"])
            # equals the above, see the class Symbol
            # The Unary & is almost the equivalent of calling #to_proc on the object,
            names.map(&:capitalize.to_proc).must_equal(["Bob", "Bill", "Heather"])
            # equals the above
            names.map(&:capitalize).must_equal(["Bob", "Bill", "Heather"])
        end
    end
end
