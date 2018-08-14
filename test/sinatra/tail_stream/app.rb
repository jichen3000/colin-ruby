require 'sinatra'
require_relative "tail_test"

set :server, :thin


def run_command(count, log_name="app.log", interval_seconds=0.2)
    count.times do |i|
        # puts i
        system("echo #{i} >> #{log_name}")
        system("ps -ef|grep ruby >> #{log_name}")
        sleep(interval_seconds)
    end
end

get '/' do
  send_file "index.html"
end

get '/run' do
  # puts params.inspect
  # puts request.body.read.inspect
  # puts "Last-Event-Id: #{request.env['HTTP_LAST_EVENT_ID']}"
  log_name = "app.log"
  system("echo '!!!start' > #{log_name}")
  run_thread = Thread.new do |thread|
    run_command(3, log_name)
    system("echo '!!!end' >> #{log_name}")
  end
  timeout_seconds = 10

  content_type "text/event-stream"

  stream do |stream_out|
    TailHelper.wait_last_line(log_name, timeout_seconds) do |last_line|
      stream_out << "data: #{last_line}\n\n"
      puts "-----"
      puts last_line
      last_line.start_with?("!!!end")
    end
  end

end