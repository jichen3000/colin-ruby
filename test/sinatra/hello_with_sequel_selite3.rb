#require 'bundler/setup'

require 'sinatra'
requirre 'sqlite3'
require 'sequel'
db_filename = File.join(File.dirname(__FILE__),'simple.db')
db = Sequel::sqlite(db_filename)
require File.join(File.dirname(__FILE__),'models.rb')
# http://localhost:4567/
get "/" do
  #"Hello world. time:#{Time.now}"
  db[:people].first[:name]  
  Person.first.name
end
