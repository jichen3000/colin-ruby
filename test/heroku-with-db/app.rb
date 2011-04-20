#require 'bundler/setup'

require 'sinatra'
require 'pg'
require 'sequel'
db=Sequel.connect(ENV['DATABASE_URL'])
#db=Sequel.connect('postgres://colin@72.46.131.199/colindb')
require File.join(File.dirname(__FILE__),'models.rb')
# http://localhost:4567/
get "/" do
  #"Hello world. time:#{Time.now}"
  #db[:people].first[:name]  
  #ENV['DATABASE_URL']
  Person.first.name
end
