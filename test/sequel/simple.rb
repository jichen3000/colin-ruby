require 'sqlite3'
require 'sequel'

db_file_name=__FILE__.sub(".rb",".db")
db = Sequel.sqlite(db_file_name)
db.drop_table :person
db.create_table :people do
  primary_key :id
  Int :role_id
  String :name
  Int :income  
  DateTime :created_at
  DateTime :updated_at
end
db.create_table :roles do
  primary_key :id
  String :permission
  DateTime :updated_at
end

role_set = db[:roles]
role_set.insert(:permission=>'SUPER')
role_set.insert(:permission=>'NORMAL')

person_set = db[:people]
  
person_set.insert(:name=>"CJ",:income=>10000)
person_set.insert(:name=>"LM",:income=>6000)
person_set.insert(:name=>"FYT",:income=>5000)

  
  
puts "person count:#{person_set.count}"
puts "person avg income:#{person_set.avg(:income)}"
puts "person sum income:#{person_set.sum(:income)}"

person_set.each do |person|
  p person
end
person_set.map(:name).each do |person_name|
  p person_name
end
p "ok"