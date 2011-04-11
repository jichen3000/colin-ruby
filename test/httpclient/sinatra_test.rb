require 'sinatra'
Sinatra::Application.port = '2345'
post "/action" do 
  p "hello"
  p params
end

post "/*" do 
  p "other"
  p params
  p params.to_s
  params.to_s
#  params
end