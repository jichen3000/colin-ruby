require 'sinatra/base'

class MyApp < Sinatra::Base
#   set :sessions, true
#   set :foo, 'bar'

  post "/*" do
  end
end