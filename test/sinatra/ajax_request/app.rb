require 'sinatra'
require 'sinatra/custom_logger'
require 'json'

$cur_dir = File.dirname(__FILE__)

set :root, $cur_dir
# set :server, %w[thin mongrel webrick]
set :bind, '0.0.0.0'
set :port, 4321

$count = 0

get "/" do
    logger.info("get /")
    @the_title = "test ajax request"
    @refresh_mins = 10
    haml :index
end

get "/sleep/:seconds" do |seconds|
    logger.info("sleep / #{seconds}... count:#{$count}")
    $count += 1
    sleep(seconds.to_i)
    $count -= 1
    logger.info("sleep / #{seconds} end count:#{$count}")
    return Time.now.to_s
end