require 'ostruct'
require 'json'
if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            person = OpenStruct.new({"name"=>"colin"})
            person.pt
            person.to_h.pt
            JSON.dump(person).pt
        end
    end
end