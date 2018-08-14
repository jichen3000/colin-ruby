def run_in_thread(interval_secs = 5, &block)
    the_thread = Thread.new do
        result = yield
        Thread.current[:result] = result
    end
    while the_thread.alive?
        print(".")
        sleep interval_secs
    end
    the_thread[:result]

end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            result = run_in_thread(1) do 
                sleep 5
                6
            end
            result.pt()
        end
    end
end