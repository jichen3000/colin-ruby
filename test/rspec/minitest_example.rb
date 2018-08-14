class Colin
    def self.str
        "str"
    end
    def self.get_ture
        true
    end
    def self.output
        puts "output"
    end
    def self.error
        1/0
    end
end
if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "normal" do
            1/0
            Colin.str.must_equal("str")
            Colin.str.wont_equal("str sdfsd")
            # Colin.get_ture.must_true()

        end
        it "error" do
            error = lambda {Colin.mm}.must_raise(NoMethodError)
            error = -> {Colin.mm}.must_raise(NoMethodError)
            error = Proc.new {Colin.mm}.must_raise(NoMethodError)
            error.message.must_equal("undefined method `mm' for Colin:Class")

            Colin.str.must_equal("str1")
        end

        it "output" do
            -> {Colin.output}.must_output("output\n")
        end
        it "normal2" do
            1/0
            Colin.str.must_equal("str")
            Colin.str.wont_equal("str sdfsd")
            # Colin.get_ture.must_true()
        end
        it "error2" do
            Colin.error.must_equal("str")
            Colin.str.must_equal("str1")
        end
    end
end