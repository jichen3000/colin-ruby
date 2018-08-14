require 'sinatra'

set :server, :thin

get '/' do
  send_file "index.html"
end

get '/bottles' do
  # puts params.inspect
  # puts request.body.read.inspect
  puts "Last-Event-Id: #{request.env['HTTP_LAST_EVENT_ID']}"

  start = request.env['HTTP_LAST_EVENT_ID'] ? request.env['HTTP_LAST_EVENT_ID'].to_i+1 : 0
  puts start
  content_type "text/event-stream"

  stream do |out|
    start.upto(100000) do |i|
      out << "id: #{i}\n"
      out << "data: #{i} bottle(s) on a wall...\n\n"
      sleep 5
      print "#{i} "
    end
    out << "data: CLOSE\n\n"
  end

end