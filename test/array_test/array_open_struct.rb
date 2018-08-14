require 'ostruct'

def gen_structs(count)
    (0..count).to_a.map do |index|
        OpenStruct.new({name:"i#{index}",value:index})
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            structs_10 = gen_structs(10)
            structs_5 = gen_structs(5)
            diff = structs_10 - structs_5
            diff.ppt

        end
    end
end
