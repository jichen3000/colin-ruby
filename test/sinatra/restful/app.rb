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

#select by id
get '/people/:id' do
  Person[params[:id]].values.to_json
end

# select all
get '/people' do
  #Person.all.to_json
  result = []
  Person.all.each {|x| result<<x.values}
  result.to_json
end

# update by id
put '/people/:id' do
  values_hash = JSON.parse(params[:values])
  Person.where(:id=>params[:id]).update(values_hash)
  "1"
end

# update many
put '/people' do
  values = JSON.parse(params[:values])
  values.each do |item|
    Person.where(:id=>item['id']).update(item)
  end
  values.size.to_s
end

# insert
post '/people' do
  values = JSON.parse(params[:values])
  inserted_count = 0;
  if values.is_a?(Hash)
    Person.insert(values)
    inserted_count = 1;
  else
    values.each do |item|
      Person.insert(item)
    end
    inserted_count = values.size;
  end
  inserted_count.to_s
end


delete '/people' do
  values = JSON.parse(params[:values])
  id_arr = []
  values.each do |item|
    id_arr << item["id"]
  end
  Person.where("id in (#{id_arr.join(',')})").delete
  values.size.to_s
end

delete '/people/:id' do
  Person.where(:id=>params[:id].to_i).delete
  "1"
end



