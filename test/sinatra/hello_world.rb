require 'sinatra'
# http://localhost:4567/
get "/" do
  "Hello world. time:#{Time.now}"
end
