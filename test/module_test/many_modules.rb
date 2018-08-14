require 'testhelper'

module ColinA
    def my_p
        "ColinA".pt
        self.class.pt
        __method__.pt
    end

    def my_call_p
        "ColinA".pt
        __method__.pt
        my_p
    end
end

module ColinB
    def my_p
        "ColinB".pt
        self.class.pt
        __method__.pt
    end

    # def my_call_p
    #     "ColinB".pt
    #     __method__.pt
    #     my_p
    # end
end

class Colin
    include ColinA
    include ColinB
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            c = Colin.new
            c.my_call_p
            Colin.ancestors.pt
        end
    end
end