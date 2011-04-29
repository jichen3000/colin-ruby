require 'rspec'
require 'rack/test'
require File.join(File.dirname(__FILE__),'hello_world.rb')

#ENV['RACK_ENV']='test'
set :environment, :test

describe 'The Hello World App' do
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
  it "says hello" do
    get '/'
    last_response.should be_ok
    last_response.body.should == 'Hello World'
  end

  it "says hello to a person" do
    get '/', :name => 'Simon'
    last_response.body.should be_include('Simon')
  end
end
