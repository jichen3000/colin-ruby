require 'json'

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe JSON do
        it "generate" do
            int_hash = {:a => 2}
            json_str = JSON.generate(int_hash)
            json_str.must_equal("{\"a\":2}")

            int_hash = JSON.parse(json_str)
            int_hash["a"].must_equal(2)
        end

    end
end