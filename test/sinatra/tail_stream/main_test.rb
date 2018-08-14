require_relative "tail_test"

def run_command(count, log_name="app.log", interval_seconds=0.2)
    count.times do |i|
        puts i
        system("echo #{i} >> #{log_name}")
        system("ps -ef|grep ruby >> #{log_name}")
        sleep(interval_seconds)
    end
end


def main()
    log_name = "app.log"
    system("echo '!!!start' > #{log_name}")
    run_thread = Thread.new do |thread|
        run_command(3, log_name)
        system("echo '!!!end' >> #{log_name}")
    end
    timeout_seconds = 10
    TailHelper.wait_last_line(log_name, timeout_seconds) do |last_line|
        puts last_line
        last_line.start_with?("!!!end")
    end
end

main()
