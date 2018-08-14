require 'thread'
def run_in_thread_pool(run_count, pool_size, the_proc)
    work_q = Queue.new
    (0..run_count).to_a.each{|x| work_q.push x }
    workers = (0...pool_size).map do |thread_index|
        Thread.new do
            begin
                while run_index = work_q.pop(true)
                    the_proc.call(run_index, thread_index)
                end
            rescue ThreadError
                # avoid Queue is empty
            end
        end
    end
    workers.map(&:join)
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            run_count, pool_size = 10, 3
            run_in_thread_pool(run_count, pool_size, Proc.new { |run_index, thread_index|
                    puts "run_index #{run_index} in thread #{thread_index}"
                })
        end
    end
end