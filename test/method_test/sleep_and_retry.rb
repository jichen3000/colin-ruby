module Helper
    def self.sleep_and_retry(timeout, retry_interval, first_sleep, error_class, &block)
        wait_time = first_sleep
        sleep(first_sleep)
        begin
            result = yield
        rescue error_class => e
            if wait_time < timeout
                puts "retry after #{retry_interval} seconds, and have waited #{wait_time}"
                wait_time += retry_interval
                sleep retry_interval
                retry
            else
                raise "Error: timeout, wait #{wait_time}!!"
            end          
        end
        result        
    end
end



if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    class MyError < StandardError
    end

    $try_times = 0
    def some(msg)
        if $try_times < 3
            $try_times += 1 
            raise MyError.new("my error")
        end
        msg
    end

    describe "some" do
        it "function" do
            msg = "1234"
            timeout, retry_interval, first_sleep = [20, 1, 1]
            Helper.sleep_and_retry(timeout, retry_interval, first_sleep, MyError) do 
                some(msg).must_equal(msg)
            end
        end
    end
end