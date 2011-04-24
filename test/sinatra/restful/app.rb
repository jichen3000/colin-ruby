require 'sqlite3'
require 'sequel'
require 'sinatra'
require 'fileutils'
source_db_filename = File.join(File.dirname(__FILE__),'simple.db')
using_db_filename = source_db_filename.sub('simple.db','using.db')
FileUtils.copy(source_db_filename,using_db_filename)
db=Sequel.sqlite(using_db_filename)
Sequel::Model.plugin :json_serializer
require File.join(File.dirname(__FILE__),'models.rb')

get '/people/:id' do
  Person[params[:id]].to_json
end

get '/people' do
  Person.all.to_json
end

put '/people/:id' do
end

post '/people' do
end

delete '/people' do
end

delete '/people/:id' do
end



