def first_location
    caller_locations()
end

def first_location_label
    caller_locations(1,1)[0].label
end
# puts me

# def me_proc
#     proc do
#         p caller_locations()
#         puts caller_locations(1,1)[0].label
#         "me"
#     end
# end

me_p =     proc do
        p caller_locations()
        puts caller_locations(1,1)[0].label
        "me"
    end
p me_p.call

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "caller_locations" do
            first_location().ppt
            first_location_label().to_s.must_equal("block (2 levels) in <main>")
        end
    end
end