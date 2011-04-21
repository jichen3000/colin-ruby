require 'sqlite3'
require 'sequel'
require 'sinatra'
db=Sequel.sqlite(File.join(File.dirname(__FILE__),'simple.db'))
require File.join(File.dirname(__FILE__),'models.rb')


get '/people/[:name]' do
  Person[params[:name]]
end

get '/people' do
  #People.all
  p Person.first
  'people all'
end