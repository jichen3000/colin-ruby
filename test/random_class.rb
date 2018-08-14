class ConfigRandom < Random
    def gen_mac()
        return "09:ab:cd:"+rand(255).to_s(16)
    end
end

class FakeRandom < ConfigRandom
    def initialize(value_queue)
        @value_queue = value_queue
    end
    def rand(some=nil)
        # @value_queue.pt
        @value_queue.shift
    end
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "Random" do
        it "gen_mac" do
            my_rand = ConfigRandom.new(2)
            my_rand.gen_mac().must_equal("09:ab:cd:a8")
        end
        it "can be sub class" do
            my_rand = FakeRandom.new([255])
            my_rand.gen_mac().must_equal("09:ab:cd:ff")
        end
    end
end
